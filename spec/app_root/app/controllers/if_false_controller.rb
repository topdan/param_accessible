class IfFalseController < ApplicationController
  
  param_accessible :foo, :if => :admin?
  param_accessible({:bar => [:baz]}, :if => :admin?)
  
  protected
  
  def admin?
    false
  end
  
end
