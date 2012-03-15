class MergeController < ApplicationController
  param_accessible :a, :only => :create
  param_accessible :b
  param_accessible({ :h => :c}, :except => :update)
  param_accessible :h => :b
end
