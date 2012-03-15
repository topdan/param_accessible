class OnlyController < ApplicationController
  
  param_accessible :foo, :only => :create
  param_accessible({:bar => [:baz]}, :only => :update)
  
end
