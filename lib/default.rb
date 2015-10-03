module FormsAutofill

  class Default < Section ## will need to abstract pdfsection as well
    attr_reader :fields

    def initialize home, method, id
      methods = [:num, :name, :field]
      raise ArgumentError unless methods.include? method
      @home = home
      @fields = get_field(method, id)
      @value = @fields[0].value
    end

  private
    def get_field(method, id)
      #gets the field per method
      #returns hash {num => field}
    end

  end

  class MultiSection < Section
    attr_reader :sections

    def initialize home, &mapping
      @home = home
      @mapping = mapping
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


    