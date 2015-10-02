

module FormsAutofill


  class PdfSection
    require "json"
    attr_reader :name, :fields, :home, :meta

    #a section of pdf document - containing info on fields
    def initialize home, options = {}
      defaults = {:name => "", :meta => ""}#:template => nil}
      options = defaults.merge(options)
      @name = options[:name]
      @home = home #a Pdf object
      @meta = options[:meta]
      @fields = {}
      if @home.class != PdfForms::Pdf
        raise TypeError, "home Pdf is not a Pdf object"
        exit
      end
    end

    def add_field_by_num num
      add_field home.fields[num]
    end

    def to_json
      {
        :pdf => @home.path,
        :name => @name,
        :description => @meta,
        :fields => @fields.map {|key, value| key}
      }.to_json
    end

    def self.from_json input_json, home
      parsed = JSON.parse(input_json)
      new_section = PdfSection.new :name => parsed["name"], :home => home

      parsed["fields"].each do |id|
        new_section.add_field home.fields[id]
      end
      new_section
    end

    def self.from_hash input_hash, home
      parsed = JSON.parse(input_hash)
      new_section = PdfSection.new :name => parsed["name"], :home => home

      parsed["fields"].each do |id|
        new_section.add_field home.fields[id]
      end
      new_section
    end

  private

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

    
    def get_field id
      begin
        field = @home.fields.index(id)
        raise 
      rescue field.class PdfForms::Field
        return nil
    # def roles
    #     @roles ? @roles : @roles = template.role_hash
    # end

    # def roles= input
    #     @roles = input
    # end

    # def assign 
    #     @roles.each do |role, field|
    #         field.role = role
    #     end
    # end

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