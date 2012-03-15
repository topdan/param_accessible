module ParamAccessible
  
  class Rules < Array
    
    def initialize parent = nil
      content = (parent.to_a if parent) || []
      super content
    end
    
    def detect_inaccessible_params controller
      accessible_params = {}
      
      each do |rule|
        rule.accessible_params_for controller, accessible_params
      end
      
      detect_inaccessible_hash controller.params, accessible_params, []
    end
    
    def push *args
      super Rule.new(*args)
    end
    
    protected
    
    def detect_inaccessible_hash hash, accessible, errors, prefix = nil
      hash.each do |key, value|
        if !accessible.has_key?(key)
          errors.push prefix_for(prefix, key)
          
        elsif value.is_a?(Hash)
          nested = accessible[key] || {}
          detect_inaccessible_hash value, nested, errors, prefix_for(prefix, key)
          
        elsif value.is_a?(Array)
          nested = accessible[key] || {}
          value.each do |v|
            if v.is_a?(Hash)
              detect_inaccessible_hash v, nested, errors, prefix_for(prefix, key)
            end
          end
        end
      end
      
      errors
    end
    
    def prefix_for prefix, key
      if prefix
        "#{prefix}[#{key}]"
      else
        key
      end
    end
    
  end
  
end
