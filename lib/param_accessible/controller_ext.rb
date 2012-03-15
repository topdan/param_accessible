module ParamAccessible
  
  module ControllerExt
    extend ActiveSupport::Concern
    
    protected
    
    def ensure_params_are_accessible
      inaccessible_params = param_accessible_rules.detect_inaccessible_params self
      
      unless inaccessible_params.nil? || inaccessible_params.blank?
        raise ParamAccessible::Error.new(inaccessible_params)
      end
    end
    
    def param_accessible_rules
      self.class.param_accessible_rules
    end
    
    module ClassMethods
      
      def param_accessible *args
        param_accessible_rules.push *args
      end
      
      def param_accessible_rules
        return @param_accessible_rules if defined? @param_accessible_rules
        
        # inheritance
        if superclass.respond_to?(:param_accessible_rules)
          @param_accessible_rules = Rules.new superclass.param_accessible_rules
        else
          common_rails_parameters_rule = Rule.new :controller, :action, :id, :format
          @param_accessible_rules = Rules.new [common_rails_parameters_rule]
        end
      end
      
    end
    
  end
  
end
