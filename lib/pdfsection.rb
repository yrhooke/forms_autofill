

module FormsAutofill


  class PdfSection
    require "json"
    require "utils" # to cange PdfForms::Field attributes to access meta + role

    attr_reader :name, :fields, :home, :meta
    attr_accessor :role

    #a section of pdf document - containing info on fields
    def initialize home, options = {}
      defaults = {:name => "", :meta => "", :role => nil}#:template => nil}
      options = defaults.merge(options)
      @name = options[:name]
      @home = home #a Pdf object
      @meta = options[:meta]
      # @role = options[:role]
      @value = nil # value is the assigned value
      @fields = {}
      if @home.class != PdfForms::Pdf
        raise TypeError, "home Pdf is not a Pdf object"
        exit
      end
    end


    def add_field_by_num num
      raise TypeError unless num.class == Fixnum
      raise RangeError, "#{num} out of range." if num >= home.fields.length
      @fields[num] = @home.fields[num]
    end


    def assign! value
      fields.each{|id, field| field.value = value}
    end

    def to_hash
      JSON.parse (self.to_json)
    end



    def self.from_hash input_hash, home
      new_section = PdfSection.new home, 
        :name => input_hash["name"],
        :meta => input_hash["meta"],
        :role => input_hash["role"]
      input_hash["fields"].each do |id|
        new_section.add_field home.fields[id]
      end
      new_section
    end

  private

    def add_field field
      if field.class == PdfForms::Field
        id = @home.fields.index(field)
        @fields[id] = field
      else
        raise TypeError
        nil
      end
    end

    def to_json
      {
        :pdf => @home.path,
        :name => @name,
        :role => @role,
        :meta => @meta,
        :fields => @fields.map{|key, value| key}
      }.to_json
    end


    # def get_field id
    #   begin
    #     field = @home.fields.index(id)
    #     raise 
    #   rescue field.class PdfForms::Field
    #     return nil


 

    # def include? section
    #     (section.class == self.class && section.subsection?(self) ) ? true : false
    # end

    # def subsection? section
    #     (@fields.all? {|id, field| section.fields[id] == field}) ? true : false
    # end

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