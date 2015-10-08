module FormsAutofill

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
        result.import_subsections! hash #__ISSUE: does this do what we wnat?
        # result.name = hash[:name]
        # hash[:fields].each {|field| result.add_field field[:id]}
        result
      end
    end

  # private

    def get_field_by_num num
      @home.fields[num]
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
      @sections = {}  #__NOTE: sections are added in hash with range from value
                      # as keys, and Section object as values
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

  # private

    def import_subsections hash
      hash[:sections].each do |range, subsection| 
        self.sections[range] = subsection[:class].import(subsection, @home)
      end
    end

  end

end
