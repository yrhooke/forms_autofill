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
    attr_accessor :sections

    @@pdftk_path = puts File.realpath(__dir__) + "/../bin/pdftk"

    def initialize form
      @pdftk = PdfForms.new @@pdftk_path
      @form = PdfForms::Pdf.new form, @pdftk
      @fields = @form.fields
      @sections = []
    end

    # def add_section  section
    #   #__NOTE: should accept any kind of section, not just PdfSection
    #   if section.class == PdfSection
    #     add_section_object section
    #   elsif section.class == Hash
    #     add_section_hash section
    #   elsif section.class == Array
    #     add_section_arr section
    #   else
    #     raise TypeError, "section(s)' class not recognized"
    #   end
    #   @sections
    # end

    def create_defaults
      @fields.each_with_index do |field, index|
        newsection = Default.new @form
        newsection.add_field index
        add_section section
      end
      @sections
    end

    def add_section section
      @sections << section
    end

    # can change and remove sections manually for now

    def export
      @sections.map {|section| section.fields}
    end


    # def assign! 
    #   @sections.each do |section|
    #     section.assign!
    #     new_section = PdfSection.from_hash section, @form
    #     new_section.assign!
    #   end
    # end

    # def fill! info
    #   #should ultimately handle Defaults, Sections, and MultiSections
    #   info.each do |role, value|
    #     @fields.each do |field| 
    #       if field.role == role
    #         field.value = value
    #       end
    #     end
    #   end
    # end

    def write values, destination
      pdftk.fill_form @form.path , destination, make_hash
    end

    # def self.read_defaults form
    #   #shoudl return Controller with defaults preset with values in form
    #   #this hash should be readable to FormController
    #   #making the processing of a new pdf - filling it with all the values you
    #   #don't change + reading. Then finding locations of values you do change 
    #   # and defining sections on those values - should add a cleanup method
    #   # then exporting this whole thing into something. so you can with one command
    #   # know for a particular form what values need to be filled. 
    # end
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