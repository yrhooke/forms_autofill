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


#     # left hand: json that says first, middle, and last name.
#     # right hand: my sections + templates
#     # action: take left hand and map to right hand correctly, including duplicates

#     def feed info, form
#         info.each do |role, value|
#             form.fields.each do |field| 
#                 if field.role == role
#                     field.value = value
#                 end
#             end
#         end

#     end

#     def make_hash pdf
#         newvals = Hash.new
#         pdf.fields.map {|field| newvals[field.name.to_sym] = field.value}
#         newvals
#     end

#     #then pdftk.fill_form input, output_path, (result of make_hash)


# end


# # class AssignmentTree

# #     role

# #     subroles

# #     assignment to each

# #     assignment can be section or field

# #     we use this to map out the form

# #     the form is split into x major sections. each section has a role. each section is split into smaller sections, each of which also has a role. And so on until we get to individual fields. 

# #     we can repeat roles, but then we repeat the names of the roles and subsections exactly. More nuance later. 

#     class Assignment
#         destination is for every template, there is a section. 
#         we have a document template, and everything is inside that. 
#         each leaf in template gets assigned a real value. 

#         the execution of a particular filling out of a form is taking a master template for the form, and taking a mapping of all leaves to values, and filling in the values in the right places. 

#         so three layers of concreteness: user's values, template (structure of values in form), and section - particular places in form that have values. so assignment is taking tree, and filling in a concrete location for each leaf.
#             that's what the section is. A template and the places the leaves go for this particular template. 

#             so each instance of a template has a section. 

#             another thing I want is defaults - sections that just have values, regardless of template system. That might complicate things, and it might not. 

#         so: 

#         assign name:
#             where does firstname go?
#             where does middlename go?
#             whre does lastname go?

#         alternatively, we can list all instances of firstname, etc. 

#         i'm slightly overting'ing this. 

#         defaults = list of fields/values

#         non-defaults - some data structur ethat can be translated to list of fields and values. 

#         simple. name: list of places name goes.
#         address: list of places where address goes. 
#         then you fill these in. 

#         use template for ss# ? 

#         sure - why not. that'll be the none empty template. '


#         name:
#         user value:
#         locations: 

#         $user inputs include name.

#         convert - 



    $defaults = {}
    $user_inputs = {}
    $locations = {}
    $pdf = ____

    def read_defaults file
        text = File.read(file)
        hash = JSON.parse(text)
        defaults = Hash[hash.map{ |k, v| [k.to_sym, v] }]
        $defaults = defaults
    end

    def read_locations file
        text = File.read(file)
        arr = JSON.parse(text)
        arr.each |section|
            input_field = PdfSections.from_json section
            $locations[input_field.name] = input_field
        end
    end

    class UserInput

        def initialize value, locations
            @value = value
            @locations = locations
            $user_inputs += self
        end

        def convert
            @locations.each do |spot|
                $user_inputs[$pdf.fields[spot].name.to_sym] = @value
            end
        end

    end

    def get_name
        puts "First name? "
        firstname = gets.chomp

        needed_info = [:first_name, :middle_name, :last_name, :dob]
    end


    

    def write
        pdftk.fill_form blank, destination, $defaults.merge($user_inputs)
    end

#     class Template
#         # example: 
#         # {
#         #     role: personal_info
#         #     sub_roles: [
#         #         fullname,
#         #         socialsecurity,
#         #         birthdate,
#         #         address,
#         #         home_phone_num,
#         #         cell_phone_num,
#         #     ]
#         # }

#         # {
#         #     role: fullname,
#         #     sub_roles: [
#         #         first_name,
#         #         middle_name,
#         #         last_name
#         #     ]
#         # }

#         # {
#         #     role: socialsecurity,
#         #     sub_roles: [
#         #         ss_block1
#         #         ss_block2
#         #         ss_block3
#         #     ]
#         # }
#         # etc.
#         attr_reader :role, :sub_roles

#         def initialize role, subroles = []
#             @role = role
#             @sub_roles = subroles
#             $templates[@role] = self
#         end

#         def tree
#             branches = @sub_roles.inject({}) do |result, trait|
#                 if $templates[trait].sub_roles == []
#                     result[trait] = []
#                 else
#                     result[trait] = $templates[trait].tree
#                 end
#                 result
#             end
#             {@role => branches}
#         end

#     end

# $templates = {}
# end


#         class Template

#         def initialize
#             @role = :name
#             @subroles = [:first_name, :middle_name, :last_name]
#         end 
#         # def initialize info, option = {}
#         #     defaults = {:action => nil} #action is a proc
#         #     options = defaults.merge(options)
#         #     @info = info
#         #     @action = options[:action]
#         # end

#         def role_hash 
#             @roles.inject({}) do |result, role|
#                 result[role] = nil
#                 result
#             end
#         end
#         # def execute &proc = @action
#         #     return proc.to_s
#         # end

        
#     end


# roles expand: each section has some roles, and there's an expansion of roles until we get to individual field's roles. 


# # an example template would be first middle last name

# # execute would be assigne first middle last name to section

# # does template sit on section or does it sit on incoming info?

# # template connects incoming value with section. 

# # a particular instance of template sits on a particular section. a particular subclass of template sits on a kind of section. 

# # a sucblass of template is a particular list of parts

# # an instance of template is an assignation of parts to a particular section
# # so 



# # in the whole document, there will be a list of templates: all fullname templates, all social security templates, etc. 

# # 1. save object to fdf/ write to pdf from object

# # 2. sections organize the information, now we want something that can fill in that information. 




# # left hand: json that says first, middle, and last name.

# # right hand: my sections + templates

# # action: take left hand and map to right hand correctly, including duplicates

# # class PdfForms::Field
# #     # to be able to note some info about fields
# #     attr_accessor :role, :value
# # end

# # def assign_name pdf
# #     pdf.fields.each do |field|
# #         if field.name.downcase.include? "name"
# #             field.role = :name
# #         end
# #     end
# # end

# # def feed info, form
# #     info.each do |role, value|
# #         form.fields.each do |field| 
# #             if field.role == role
# #                 field.value = value
# #             end
# #         end
# #     end

# # end

# # def make_hash pdf
# #     newvals = Hash.new
# #     pdf.fields.map {|field| newvals[field.name.to_sym] = field.value}
# #     newvals
# # end

# # what we want is a more nuanced way to assign roles to fields. 

# # def assign_as_name arr
# #     arr[0].role = :first_name
# #     arr[1].role = :middle_name
# #     arr[2].role = :last_name
# # end

# # def assign_as_phone arr
# #     arr[0].role = :phone_area
# #     arr[1].role = :phone_first
# #     arr[2].role = :phone_second
# # end


# # def assign roles, arr

# # end


# # so section has a template
# # assign assigns the fields in the section the roles in the template and saves this mapping to @roles.