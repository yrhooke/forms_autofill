require "forms_autofill/version"

module FormsAutofill
    require "pdf-forms"
    pdftk = PdfForms.new(Dir.pwd + "/bin/pdftk")

    blank_path = "./db/1010-blank.pdf"
    indices_path = "./tmp/indices.pdf"
    # Pdf forms commands are all based on SafeShell.execute which takes comma sepearated arguments, and the pdftk binary  - docs here: https://www.pdflabs.com/docs/pdftk-man-page/

    # Commands used via command line to fill pdf:
    # pdftk ./db/1010-filled-sample.pdf generate_fdf output ./tmp/sample2.fdf
    # pdftk ./db/1010-blank.pdf fill_form ./tmp/sample2.fdf output ./tmp/filled2.pdf
    # our pdftk instance has a call_pdftk method, which takes the same arguments as pdftk, but as comma separated vaues
    # i.e: 
    #     pdftk.call_pdftk("./db/1010-blank.pdf", "fill_form", "./tmp/sample2.fdf", "output", "./tmp/filled.pdf")
    # will do the same thing as above

    # class PdfForms::DataFormat
    #     ## to fix format of fdf
    #     def to_pdf_data
    #         pdf_data = header
    #         @data.each do |form_part|
    #             pdf_data << field(form_part.name, form_part.value)
    #         end  
    #         pdf_data << footer
    #         return encode_data(pdf_data)
    #     end  
    # end  

    class PdfForms::PdftkWrapper

        def extract_fdf_bin input, output
            self.call_pdftk(input, "generate_fdf", "output", output)
        end

        def fill_form_bin params = {:input => "", :output => "", :fdf => ""}
            #params are input, output, fdf
            self.call_pdftk params[:input], "fill_form", params[:fdf], "output", params[:output]
        end
    
    end

    class PdfForms::Field
        # to be able to note some info about fields
        attr_accessor :meta
    end



    #generate fdf with specific values for each key in existing pdf
    
    def fill_with_index location, output, pdftk
        keys = pdftk.get_field_names location
        indices = Hash.new
        keys.each_with_index {|key, index| indices[key] = index}
        pdftk.fill_form location, output, indices
    end

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

        def == section
            self.subsection? section && section.subsection? self ? true : false
        end

        # def truthcondition &prc
        #     status = nil
        #     prc ? status = true : status = false
        #     status
        # end

    end

pdf object - has fields

add sections



  # Your code goes here...
end


##what do we want to do:

# #we want to be able to extract an fdf template from a filled in pdf
# #We want template to remember from what pdf as well
# #We want to be able to add fdf template to pdf to fill it.
# #we want to be able to add fields to fdf template


# so: 

# stage 1:
# 1. extract fdf object from pdf
# 2. save fdf object
# 3. use existing fdf object or a file it's from to add info to pdf


# stage 2: edit fdf object + standardize ways to do so.
# 1. create fdf template object - remembers what pdf it's from. 
# 2. fdf template should know which fields in fdf have same/similar information
# 3. have methods for auto-filling in these fields based on some input. 
# 4. 

# stage 3: web server

# stage 4: be able to add new forms easily
# objects: 

# pdf - a form with all the info/visuals
# fdf - just the form information for a pdf

# we manipulate fdf, and eventually write to pdf

# what manipulation do we do to fdf?

#     we change the value of some entries in fdf's @data

# that's basic level

# to change 1010 form we need to insert some info to the appropriate places:
#     name, DOB, entry date, address, alien ID number

# to do this well we want to:
#     1. know what places are important - per form (1010)
#     2. have a function to fill them in

# let's deal with filling them in later. 

