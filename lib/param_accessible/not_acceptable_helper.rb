module ParamAccessible
  
  module NotAcceptableHelper
    extend ActiveSupport::Concern
    
    included do
      rescue_from ParamAccessible::Error, :with => :handle_param_not_accessible
    end
    
    protected
    
    def handle_param_not_accessible error
      respond_to do |format|
        format.html { render :status => 406, :text => error.message }
        format.json { render :status => 406, :json => {:error => {:message => "You supplied invalid parameters: #{error.inaccessible_params.join(', ')}"}} }
        format.xml  { render :status => 406, :xml => {:message => "You supplied invalid parameters: #{error.inaccessible_params.join(', ')}"}.to_xml('error') }
        format.js   { render :status => 406, :text => %(// invalid parameters: #{error.inaccessible_params.join(', ')}\n) }
      end
    end
    
  end
  
end
