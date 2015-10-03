module FormsAutofill
  # left hand: json that says first, middle, and last name.
  # right hand: my sections + templates
  # action: take left hand and map to right hand correctly, including duplicates

  class FormController
    require "pdf-forms"
    attr_reader :sections

    @@pdftk_path = puts File.realpath(__dir__) + "/../bin/pdftk"

    def initialize form
      @pdftk = PdfForms.new @@pdftk_path
      @form = PdfForms::Pdf.new form, @pdftk
      @fields = @form.fields
      @sections = []
    end


    def import_sections sections_json, options = {}
      # accepts JSON, adds it to @sections
      defaults = {:overwrite => false}
      options = defaults.merge(options)
      new_sections = JSON.parse(sections_json)
      if options[:overwrite]
        @sections = new_sections
      else
        @sections.concat new_sections
      end
      @sections
    end

    def add_section  section
      @sections << section.to_hash
    end

    def assign_sections! 
      @sections.each do |section|
        new_section = PdfSection.from_hash section, @form
        new_section.assign
      end
    end


    def fill info
      info.each do |role, value|
        @fields.each do |field| 
          if field.role == role
            field.value = value
          end
        end
      end
    end

    def make_hash 
      #creates hash of the fields parameters
      newvals = Hash.new
      @fields.map {|field| newvals[field.name.to_sym] = field.value}
      newvals
    end

    def write values, destination
      fill values
      pdftk.fill_form @form.path , destination, make_hash
    end
  end
end