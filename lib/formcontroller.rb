module FormsAutofill
  # left hand: json that says first, middle, and last name.
  # right hand: my sections + templates
  # action: take left hand and map to right hand correctly, including duplicates

  # Procedure is:
  # form = FormController new pdf_path
  # form.add_section #whatever section or sections you want, 
  # form.create_defaults - creates default sections for all the rest
  # form.fill! user_input - the user input you want, in terms of section names
  # form.write destination


  class FormController
    require "pdf-forms"
    attr_accessor :sections
    attr_reader :form 

    @@pdftk_path = File.realpath(__dir__) + "/../bin/pdftk"

    def initialize form_path
      @pdftk = PdfForms.new @@pdftk_path
      # @form_path = form_path
      @form = PdfForms::Pdf.new form_path, @pdftk
      @form.fields.each_.with_index do |field, index| 
        field.id = index
      end
      @sections = []
    end



# 1. field id added when adding to section
# 2. field id added when @field created. - that's no good. 


# issues: field id assigned in 2 places. 
# create defaults create multiple copies of multisections. 
    def create_defaults
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


    # def create_defaults
    #   # take all unassigned fields, make unnamed sections from them.
    #   @fields.each_with_index do |field, index|
    #     newsection = Section.new @form
    #     newsection.add_field index
    #     add_section(newsection)
    #   end
    #   @sections
    # end

    def add_section section
      @sections << section
      # relevant_fields = select_fields(section).map{|field| field.to_hash}
      # @fields.delete_if {|field| relevant_fields.include? field.to_hash} #__ISSUE: not sure if this will work - might be different objects
    end


    def export
      {
        :pdftk_path => @@pdftk_path,
        :form_path => @form.path,
        :sections => sections.map{|section| section.export}
      }
    end

    def fill! user_data
      # example{"name" => "James", "DOB" => "05/03/2010"}
      user_data.each do |label, value|
        relevant_section = @sections.select {|section| section.name == label}
        relevant_section.first.assign! value
      end
    end

    def self.import data
      # creates a new FormController with the right form, and the right sections defined, and the default values
      # structure should be same as export output. 
      controller = FormController.new data[:form_path]
      data[:sections].each do |section_hash| 
        section = Section.import section_hash, controller.form
        controller.add_section section
      end
      controller
    end

    # def fast_section id
    #   newsec = mksection @fields[id].name, [id]
    #   add_section newsec
    # end
    # def store_field field

    # No assign for form - too complicated.
    # assign values to the individual sections. 
    # manually create sections like firstname, phonenum, etc. 
    # manually assign them values.

    # so now create_defaults can read a pdf and make sections. You define the sections containing multiple fields and the multisections manually. 
    # 2 kinds of functionality -
    #   1 is having a steady state to store values in the way they're organized
    #   2 is writing them down. 
    #   3 I want to add six values, have them be assigned to multisections/sections, 
        # have all the rest added from someplace, and write all this on top of the blank pdf. 
    # have export/impo



# 3. cases: one value per section - defaults
#           one value for multiple secitons - PdfSection
#           value mapped to multiple pdfsections. - MultiSection.


# < section class='pdfsection', value='something'> (works for default as well)
#   <listelt - name = whatever, id = whatever, value = sectionvalue>
# < section class='multisection' value='something', mapping = 'way split works'>
#   <section class='pdfsection', value='result of mapping'>
#     <listelt - name = whatever, id = whatever, value = sectionvalue(0..4)>


# section has class, value, fields - add id attribute to field. 

# multisection has class, value, mapping, and sections. 


    def write destination
      pdftk.fill_form @form.path , destination, make_hash
    end


    def clear?
      # test whether it contains duplicates fields
      fields.uniq == fields
    end

    def make_hash 
      #creates hash of the fields parameters
      fields = @sections.map{|section| select_fields section}.flatten
      result = Hash.new
      fields.each {|field| result[field.name.to_sym] = field.value}
      # @fields.map {|field| newvals[field.name.to_sym] = field.value}
      result
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



# old:
#     def import_sections sections_json, options = {}
#       # accepts JSON, adds it to @sections
#       defaults = {:overwrite => false}
#       options = defaults.merge(options)
#       new_sections = JSON.parse(sections_json)
#       if options[:overwrite]
#         @sections = new_sections
#       else
#         @sections.concat new_sections
#       end
#       @sections
#     end