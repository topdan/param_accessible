class ExceptController < ApplicationController
  
  param_accessible :foo, :except => :create
  param_accessible({:bar => [:baz]}, :except => :update)
  
end
