module FormsAutofill
  
  # class Section
  #   attr_reader :value
  #   attr_accessor :name

  #   def initialize home
  #     @home = home
  #     @name = nil
  #   end

  #   # @@HASHABLE = [] # attributes to be converted to/from hash

  #   def assign!
  #     #give relevant fields the relevant value
  #   end

  #   def to_hash
  #   # # TEMPLATE:
  #   #   {
  #   #     :pdf => @home.path,
  #   #     :name => @name,
  #   #     :role => @role,
  #   #     :meta => @meta,
  #   #     :fields => @fields.map{|key, value| key}
  #   #   }
  #   end

  #   def self.from_hash input_hash, home
  #   # # Template:
  #   #   new_section = PdfSection.new home, 
  #   #     :name => input_hash["name"],
  #   #     :meta => input_hash["meta"],
  #   #     :role => input_hash["role"]
  #   #   input_hash["fields"].each do |id|
  #   #     new_section.add_field home.fields[id]
  #   #   end
  #   #   new_section
  #   end
  # end


  class Section ## will need to abstract pdfsection as well
    attr_reader :fields
    attr_accessor :name, :value

    def initialize home #method, id
      # methods = [:num, :name, :field]
      # raise ArgumentError unless methods.include? method
      @home = home
      @fields = []
      # @fields = get_field(method, id)
      # @value = @fields[0].value
    end

    def add_field(id)
      result = get_field_by_num(id)
      @value = result.value
      @fields << result
    end

    def assign! value
      @value = value
      fields.each{|field| field.value = value}
    end    

    def export
      {
        :class => self.class,
        :name => @name,
        :value => @value,
        :fields => @fields.map{|field| field.to_hash}
      }
    end

    def self.import hash, home
      unless home
        puts "Error with home === #{home.inspect}"
        nil
      else
        result = hash[:class].new home
        result.value = hash[:value]
        result.import_subsections hash
        # result.name = hash[:name]
        # hash[:fields].each {|field| result.add_field field[:id]}
        result
      end
    end

  # private

    def get_field_by_num num
      field = @home.fields[num]
      field.id = num
      field
    end

    def import_subsections hash
      hash[:fields].each {|field| add_field field[:id]}
      self
    end


  end


  class MultiSection < Section
    attr_accessor :sections

    def initialize home
      @home = home
      @sections = {} # sections are added in form of range as key, and Section object as value
    end

    def add_field id
      #we don't need this here
    end

    def assign! value
      @value = value
      @sections.each do |map, section|
        section.assign!(value[map]) # it's a section
      end
    end

    def export
      subsections = {}
      @sections.each {|range, subsection| subsections[range] = subsection.export}
      { 
        :class => self.class,
        :name => @name,
        :value => @value,
        :sections => subsections
      }
    end

    # def self.import hash, home
    #   result = hash[:class].new home
    #   result.value = hash[:value]
    #   # result.name = hash[:name]
    #   hash[:sections].each {|range, section| result.sections[range] = section}
    #   result
    # end

  # private

    def import_subsections hash
      hash[:sections].each do |range, subsection| 
        self.sections[range] = subsection[:class].import(subsection, @home)
      end
    end

  end


#     def add_field(id)
#       # methods = [:num, ]#:name, :field]
#       # unless methods.include? method
#       #   return nil
#       # end
#       # if method == :num
#         field = get_field_by_num( id )
#         @id = id
#         @field = field
#       # end
#       return @id, @field
#     end

#     def fields
#       {@id => @field}
#     end

#     def assign! value
#       @field.value = value
#     end

#   private

#     def get_field_by_num num
#       field = @home.fields[num]
#       return field
#     end

#     # def get_field_by_name name
#     #   id = @home.field.index(name)
#     #   #gets the field per method
#     #   #returns hash {num => field}
#     # end

#   end

#   class MultiSection < Section
#     attr_reader :sections, :mapping

#     def initialize home
#       @home = home
#       # @mapping = mapping
#       @sections = []
#     end

#     def add_section section
#       @sections << section
#     end

#     def add_mapping actions
#       @actions = actions # a list of ranges of the value: value[0..2], value[2..5] etc.
#       @mapping = {}
#       actions.each do |action|
#         @mapping[action] = nil
#       end
#       @mapping # right now mapping would be a hash with nil values
#     end

#     def assign! value
#       @mapping.each do |map|
#         @mapping[map].assign!(value[map]) # it's a section
#       end
#     end

#     def fields
#       @mapping
#     end


#   end



#     #mapping splits the value into several sections
#     # these sections will be visible in @sections
#     # you assign a PdfSection to each section
#     # the map method actually splits up the value
#     # then the assign! method assigns the split value to the sections

#     # so from FormController, you can initialize it with a full form and export defaults, 
#     # or initialize it with full sections, multisections and defaults. 
#     # it should also have a method for adding values to sections that don't have one,
#     # Then it has an assign! method to make each section assign its proper value,
#     # Then write outputs to document. 


end


#     