class ApplicationController < ActionController::Base
  before_filter :ensure_params_are_accessible, :only => [:create, :update]
  before_filter :render_nothing
  
  def index
  end
  
  def show
  end
  
  def new
  end
  
  def create
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
private

  def render_nothing
    render :nothing => true
  end
  
end
