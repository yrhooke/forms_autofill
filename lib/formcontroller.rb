module FormsAutofill

  class FormController
    require "pdf-forms"
    attr_accessor :sections
    attr_reader :form 

    @@pdftk_path = File.realpath(__dir__) + "/../bin/pdftk"

    def initialize form
      @pdftk = PdfForms.new @@pdftk_path
      @form = form
      @sections = []
    end


    def add_section section
      @sections << section #__NOTE: is this sufficient?
    end

    def export
      {
        :pdftk_path => @@pdftk_path,
        :form_path => @form.path,
        :sections => sections.map{|section| section.export}
      }
    end

    def self.import data
      # creates a new FormController sections as defined by data
      # structure should be same as export output. 
      pdftk = PdfForms.new @@pdftk_path 
      form = PdfForms::Pdf.new_with_id data[:form_path], pdftk
      controller = FormController.new form
      data[:sections].each do |section_hash| 
        section = Section.import section_hash, form
        controller.add_section section
      end
      controller
    end

    def fill! user_data
      # example{"name" => "James", "DOB" => "05/03/2010"}
      user_data.each do |label, value|
        relevant_section = @sections.select {|section| section.name == label}
        relevant_section.first.assign! value
      end
    end

    def create_defaults
      #__ISSUE: select all fields not in sections
      unless clear?
        puts "Error: Multiple sections contain the same field"
        nil
      else
        unassigned_fields = @form.fields.reject { |f| fields.include? f }
        unassigned_fields.each do |field| 
          newsection = Section.new @form
          newsection.add_field field.id
          add_section(newsection)
        end
        @sections
      end
    end    

    def write destination
      @pdftk.fill_form @form.path , destination, make_hash
    end

    # UTILS

    def clear?
      # test whether it contains duplicates fields
      fields.uniq == fields
    end

    def make_hash 
      #creates hash of the fields parameters
      # fields = @sections.map{|section| select_fields section}.flatten
      result = Hash.new
      fields.each {|field| result[field.name.to_sym] = field.value}
      # @fields.map {|field| newvals[field.name.to_sym] = field.value}
      result
    end

    def section_hash
      output = Hash.new
      @sections.each {|sec| output[sec.name] = sec.value}
      output
    end

    def select_fields section
      result = []
      if section.class == Section
        result << section.fields
      else
        result += section.sections.values.map{|subsection| select_fields subsection}.flatten
      end
      result.flatten
    end

    def fields
      @sections.map { |section| select_fields section }.flatten
    end

  end

end
