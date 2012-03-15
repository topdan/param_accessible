module ParamAccessible
  
  class Error < Exception
    
    attr_reader :inaccessible_params
    
    def initialize inaccessible_params
      if inaccessible_params.length == 1
        super "#{inaccessible_params.join(', ')} is an invalid parameter"
      else
        super "#{inaccessible_params.join(', ')} are invalid parameters"
      end
      
      @inaccessible_params = inaccessible_params
    end
    
  end
  
end
