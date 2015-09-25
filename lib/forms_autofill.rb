require "forms_autofill/version"
# require "forms_autofill/utils"

module FormsAutofill

    class PdfSection
        require "json"
        attr_reader :name, :fields, :home, :template

        #a section of pdf document - containing info on fields
        def initialize name, options = {}
            defaults ={:meta => "", :home => nil, :fields => {}, :template => nil}
            options = defaults.merge(options)
            @name = name
            @home = options[:home]
            @meta = options[:meta]
            @fields = options[:fields]
            @template = options[:template]
        end

        # def maketemplate template
        #     if template
        #         @template = template
        #         @roles = self.class.role_hash template.roles
        #     end
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

        def assign template = @template
            assignment = template.role_hash
        end
        # def assign  template = @template
        #     roles = template.roles.dup
        #     until roles = []
        #         puts @fields
        #         print "Which is #{roles[-1]}? "
        #         name = gets.chomp
        #         loop fields
        #          # get the right field
        #          # set role to role
        #         roles.pop
        #     end   
        # end

        def include? section
            (section.class == self.class && section.subsection?(self) ) ? true : false
        end

        def subsection? section
            (@fields.all? {|id, field| section.fields[id] == field}) ? true : false
        end

        # def == section
        #     self.subsection? section && section.subsection? self ? true : false
        # end

        # def truthcondition &prc
        #     status = nil
        #     prc ? status = true : status = false
        #     status
        # end

        def to_json
            {
                :pdf => @home.path,
                :name => @name,
                :description => @meta,
                :fields => @fields.map {|key, value| key}
            }.to_json
        end

        # def self.from_json input_json
        #     parsed = JSON.parse(input_json)
        #     home = 
        #     PdfSection.new parsed["name"], :home
    end

    class Template

        attr_reader :roles
        def initialize
            @roles = [:first_name, :middle_name, :last_name]
        end 
        # def initialize info, option = {}
        #     defaults = {:action => nil} #action is a proc
        #     options = defaults.merge(options)
        #     @info = info
        #     @action = options[:action]
        # end

        def role_hash 
            @roles.inject({}) do |result, role|
                result[role] = nil
                result
            end
        end
        # def execute &proc = @action
        #     return proc.to_s
        # end

    end

end



# an example template would be first middle last name

# execute would be assigne first middle last name to section

# does template sit on section or does it sit on incoming info?

# template connects incoming value with section. 

# a particular instance of template sits on a particular section. a particular subclass of template sits on a kind of section. 

# a sucblass of template is a particular list of parts

# an instance of template is an assignation of parts to a particular section
# so 

class FullName

    @@roles = [:first_name, :middle_name, :last_name]

    def assign arr
        arr[0].role = :first_name
        arr[1].role = :middle_name
        arr[2].role = :last_name
    end
end 


# in the whole document, there will be a list of templates: all fullname templates, all social security templates, etc. 

# 1. save object to fdf/ write to pdf from object

# 2. sections organize the information, now we want something that can fill in that information. 




# left hand: json that says first, middle, and last name.

# right hand: my sections + templates

# action: take left hand and map to right hand correctly, including duplicates

class PdfForms::Field
    # to be able to note some info about fields
    attr_accessor :role, :value
end

def assign_name pdf
    pdf.fields.each do |field|
        if field.name.downcase.include? "name"
            field.role = :name
        end
    end
end

def feed info, form
    info.each do |role, value|
        form.fields.each do |field| 
            if field.role == role
                field.value = value
            end
        end
    end

end

def make_hash pdf
    newvals = Hash.new
    pdf.fields.map {|field| newvals[field.name.to_sym] = field.value}
    newvals
end

what we want is a more nuanced way to assign roles to fields. 

def assign_as_name arr
    arr[0].role = :first_name
    arr[1].role = :middle_name
    arr[2].role = :last_name
end

def assign_as_phone arr
    arr[0].role = :phone_area
    arr[1].role = :phone_first
    arr[2].role = :phone_second
end


def assign roles, arr

end


so section has a template
assign assigns the fields in the section the roles in the template and saves this mapping to @roles.




