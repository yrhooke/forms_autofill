require "forms_autofill/version"
require "utils"
require "pdfsection"

module FormsAutofill
    # left hand: json that says first, middle, and last name.
    # right hand: my sections + templates
    # action: take left hand and map to right hand correctly, including duplicates


    def feed info, form
        info.each do |role, value|
            form.fields.each do |field| 
                if field.role == role
                    field.value = value
                end
            end
        end

        form
    end

    def make_hash pdf
        newvals = Hash.new
        pdf.fields.map {|field| newvals[field.name.to_sym] = field.value}
        newvals
    end

    #then 

    def add_sections sections, pdf
        #alters pdf
        mysections = []
        sections.each do |section|
            new_section = PdfSection.from_hash section, pdf
            new_section.assign
            mysections << new_section
        end
        mysections
    end

    def save_sections sections
        result = sections.map {|section| section.to_json}
        result.to_json
    end

    def write from_pdf, sections, values, result_pdf, pdftk
        #values is a hash of values, sections is an array hashes - each is PdfSection's to_json.
        pdf = PdfForms::Pdf.new from_pdf, pdftk
        add_sections sections, pdf
        feed values, pdf
        filled = make_hash pdf
        pdftk.fill_form from_pdf, result_pdf, filled
    end

    def field_by_num num, pdf
        pdf.fields[num]
    end

end







