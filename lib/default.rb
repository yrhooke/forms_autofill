module FormsAutofill

  class Default < Section ## will need to abstract pdfsection as well

    def initialize home, #method, id
      # methods = [:num, :name, :field]
      # raise ArgumentError unless methods.include? method
      @home = home
      # @fields = get_field(method, id)
      # @value = @fields[0].value
    end

    def add_field(method, id)
      methods = [:num, ]#:name, :field]
      unless methods.include? method
        return nil
      elsif method == :num
        id, field = get_field_by_num( num )
        @id = id
        @field = field
      end
      @id, @field
    end

    def fields
      {@id => @field}
    end

    def assign! value
      @field.value = value
    end

  private

    def get_field_by_num num
      field = @home.fields[num]
      id, field
    end

    # def get_field_by_name name
    #   id = @home.field.index(name)
    #   #gets the field per method
    #   #returns hash {num => field}
    # end

  end

  class MultiSection < Section
    attr_reader :sections, :mapping

    def initialize home
      @home = home
      # @mapping = mapping
      @sections = []
    end

    def add_section section
      @sections << section
    end

    def add_mapping actions
      @actions = actions # a list of ranges of the value: value[0..2], value[2..5] etc.
      @mapping = {}
      actions.each do |action|
        @mapping[action] = nil
      end
      @mapping # right now mapping would be a hash with nil values
    end

    def assign! value
      @mapping.each do |map|
        @mapping[map].value = value[map]
      end
    end



    #mapping splits the value into several sections
    # these sections will be visible in @sections
    # you assign a PdfSection to each section
    # the map method actually splits up the value
    # then the assign! method assigns the split value to the sections

    # so from FormController, you can initialize it with a full form and export defaults, 
    # or initialize it with full sections, multisections and defaults. 
    # it should also have a method for adding values to sections that don't have one,
    # Then it has an assign! method to make each section assign its proper value,
    # Then write outputs to document. 

  end

  class Section
    attr_reader :value

    def initialize home
      @home = home
    end

    @@HASHABLE = [] # attributes to be converted to/from hash

    def assign!
      #give relevant fields the relevant value
    end

    def to_hash
    # # TEMPLATE:
    #   {
    #     :pdf => @home.path,
    #     :name => @name,
    #     :role => @role,
    #     :meta => @meta,
    #     :fields => @fields.map{|key, value| key}
    #   }
    end

    def self.from_hash input_hash, home
    # # Template:
    #   new_section = PdfSection.new home, 
    #     :name => input_hash["name"],
    #     :meta => input_hash["meta"],
    #     :role => input_hash["role"]
    #   input_hash["fields"].each do |id|
    #     new_section.add_field home.fields[id]
    #   end
    #   new_section
    end
  end

end


    