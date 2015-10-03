module FormsAutofill
  # left hand: json that says first, middle, and last name.
  # right hand: my sections + templates
  # action: take left hand and map to right hand correctly, including duplicates

  # Procedure is:
  # form = FormController new pdf_you_want
  # form.add_section #whatever section or sections you want, possibly multiple times
  # form.assign!
  # form.fill! info # hash taken from elsewhere of :role => value pairs
  # form.write destination


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

    def add_section  section
      if section.class == PdfSection
        add_section_object section
      elsif section.class == Hash
        add_section_hash section
      elsif section.class == Array
        add_section_arr section
      else
        raise TypeError, "section(s)' class not recognized"
      end
      @sections
    end

    def assign! 
      @sections.each do |section|
        new_section = PdfSection.from_hash section, @form
        new_section.assign!
      end
    end

    def fill! info
      info.each do |role, value|
        @fields.each do |field| 
          if field.role == role
            field.value = value
          end
        end
      end
    end

    def write values, destination
      pdftk.fill_form @form.path , destination, make_hash
    end
  

  private

    def add_section_object section
      #__NOTE: doesn't test section owner
      @sections << section.to_hash
    end

    def add_section_hash section
      @sections << section
    end

    def add_section_arr sections
      @section.concat sections
    end

    def check_owner
      ##__IMPORTANT: implement
    end

    def make_hash 
      #creates hash of the fields parameters
      newvals = Hash.new
      @fields.map {|field| newvals[field.name.to_sym] = field.value}
      newvals
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