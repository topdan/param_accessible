class UnlessTrueController < ApplicationController
  
  param_accessible :foo, :unless => :admin?
  param_accessible({:bar => [:baz]}, :unless => :admin?)
  
  protected
  
  def admin?
    true
  end
  
end
