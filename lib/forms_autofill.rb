require "forms_autofill/version"
require "forms_autofill/utils"

module FormsAutofill

    class PdfSection
        attr_reader :name, :fields, :home

        #a section of pdf document - containing info on fields
        def initialize name, options = {:meta => "", :home => nil, :fields => {}}
            @name = name
            @home = options[:home]
            @meta = options[:meta]
            @fields = options[:fields]
        end

        # def initialize name, options = {}
        #     defaults = {:meta => "", :home => PdfForms::Pdf.new, :fields => Hash.new}
        #     options = defaults.merge(options)
        #     @name = name
        #     @home = options[:home]
        #     @meta = options[:meta]
        #     @fields = options[:fields]
        # end

        def add_field field, options={:meta => nil}
            if home
                id = @home.fields.index(field)
                @fields[id] = field
                if options[:meta]
                    field.meta = options[:meta] 
                end
            else
                @fields[field.name] = field
            end
        end

        def include? section
            (section.class == self.class && section.subsection?(self) ) ? true : false
        end

        def subsection? section
            (@home == section.home && @fields.all? {|id, field| section.fields[id] == field}) ? true : false
        end

        # def == section
        #     self.subsection? section && section.subsection? self ? true : false
        # end

        # def truthcondition &prc
        #     status = nil
        #     prc ? status = true : status = false
        #     status
        # end

    end

end


