module ParamAccessible
  
  class Rule
    
    attr_reader :attributes
    attr_reader :if_option, :unless_option
    attr_reader :only_options, :except_options
    
    def initialize *args
      if args.length > 1 && args.last.is_a?(Hash)
        options = args.last
        attributes = args[0..-2]
        
        options.assert_valid_keys :if, :unless, :only, :except
        # options = normalize_options options
      else
        options = {}
        attributes = args
      end
      
      @if_option = options[:if]
      @unless_option = options[:unless]
      
      @only_options = clean_action_option options[:only]
      @except_options = clean_action_option options[:except]
      
      @attributes = normalize_params attributes
    end
    
    def clean_action_option value
      return if value == nil
      value = [value] unless value.is_a?(Array)
      value.collect {|v| v.to_s }
    end
    
    def accessible_params_for controller, dest
      return if @if_option != nil && !controller.send(@if_option)
      return if @unless_option != nil && controller.send(@unless_option)
      
      return if @only_options != nil && !@only_options.include?(controller.action_name)
      return if @except_options != nil && @except_options.include?(controller.action_name)
      
      accessible_hash_for controller.params, @attributes, dest
    end
    
    protected
    
    def accessible_hash_for params, attributes, dest
      attributes.each do |key, value|
        if value.is_a?(Hash)
          attrs = dest[key]
          if attrs.nil?
            attrs = {}
            dest[key] = attrs
          end
          
          nested_params = params[key] if params.is_a?(Hash)
          accessible_hash_for nested_params, value, attrs
          
        elsif key.is_a?(String)
          dest[key] = value
          
        elsif key.is_a?(Regexp) && params
          accessible_params_for_regex key, params, dest
        end
      end
    end
    
    def accessible_params_for_regex regex, params, dest
      params.keys.each do |key|
        if key.to_s =~ regex
          dest[key] = nil
        end
      end
      
      dest
    end
    
    # When specifying params to protect, we allow a combination of arrays and hashes much like how
    # ActiveRecord::Base#find's :include options works.  This method normalizes that into just nested hashes,
    # stringifying the keys and setting all values to nil.  This format is easier/faster to work with when
    # filtering the controller params.
    # Example...
    #   [:a, {:b => [:c, :d]}]
    # to
    #   {"a"=>nil, "b"=>{"c"=>nil, "d"=>nil}}
    def normalize_params(params, params_out = {})
      if params.instance_of?(Array)
        params.each{ |param| normalize_params(param, params_out) }
      elsif params.instance_of?(Hash)
        params.each do |k, v|
          k = normalize_key(k)
          params_out[k] = {}
          normalize_params(v, params_out[k])
        end
      else
        params_out[normalize_key(params)] = nil
      end
      params_out
    end

    def normalize_key(k)
      if k.is_a?(Regexp)
        k
      else
        k.to_s
      end
    end

  end
  
end
