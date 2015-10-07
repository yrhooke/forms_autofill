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

    def initialize form_path
      @pdftk = PdfForms.new @@pdftk_path
      @form = PdfForms::Pdf.new form_path, @pdftk
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
        newsection = Section.new @form
        newsection.add_field index
        add_section(newsection)
      end
      @sections
    end

    # def add_section section
    #   @sections << section
    # end

    # def sub_section section
    #   #removes all defaults with section fields
    # end

    # can change and remove sections manually for now

    def export
      @sections.map {|section| section.export}
    end

    def fill! user_data
      # example{"name" => "James", "DOB" => "05/03/2010"}
      user_data.each do |label, value|
        relevant_section = @sections.select {|section| section.name == label}
        relevant_section.first.assign! value
      end
    end


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
    # def assign! 
    #   @sections.each do |section|
    #     section.assign!
    #     new_section = PdfSection.from_hash section, @form
    #     new_section.assign!
    #   end
    # end

    # def assign! valueset
    #   @sections.each do |section|
    #     section.assign!
    #     new_section = PdfSection.from_hash section, @form
    #     new_section.assign!
    #   end
    # end


# input of assign! here should be same as output of make_hash.

# section pretty much defined by fields it includes. 

# tree - leaf is [id, form name] => value
# all in array. 
# array item can be hash. 


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

    def write destination
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



    def make_hash 
      #creates hash of the fields parameters
      exported = self.export
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