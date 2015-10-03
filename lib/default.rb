module FormsAutofill

  class Default < Section ## will need to abstract pdfsection as well
    def initialize home, method, id
      methods = [:num, :name, :field]
      raise ArgumentError unless methods.include? method
      @home = home
      @fields = get_field(method, id)
    end

    
  end
end
    