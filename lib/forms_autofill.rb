require "forms_autofill/version"
require "utils"
require "pdfsection"

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

        def assign_sections! 
            @sections.each do |section|
                new_section = PdfSection.from_hash section, @form
                new_section.assign
            end
        end

        def add_section  section
            @sections << section.to_json
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


    # def feed info, form
    #     info.each do |role, value|
    #         form.fields.each do |field| 
    #             if field.role == role
    #                 field.value = value
    #             end
    #         end
    #     end

    #     form
    # end

    # def make_hash pdf
    #     newvals = Hash.new
    #     pdf.fields.map {|field| newvals[field.name.to_sym] = field.value}
    #     newvals
    # end

    # #then 

    # def add_sections sections, pdf
    #     #alters pdf
    #     mysections = []
    #     sections.each do |section|
    #         new_section = PdfSection.from_hash section, pdf
    #         new_section.assign
    #         mysections << new_section
    #     end
    #     mysections
    # end

    def save_sections sections
        result = sections.map {|section| section.to_json}
        result.to_json
    end

    # def write from_pdf, sections, values, result_pdf, pdftk
    #     #values is a hash of values, sections is an array hashes - each is PdfSection's to_json.
    #     pdf = PdfForms::Pdf.new from_pdf, pdftk
    #     add_sections sections, pdf
    #     feed values, pdf
    #     filled = make_hash pdf
    #     pdftk.fill_form from_pdf, result_pdf, filled
    # end

    # def field_by_num num, pdf
    #     pdf.fields[num]
    # end

end







