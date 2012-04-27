class NestedController < ApplicationController
  param_accessible :a => [{:"b[]" => [:d, :e, :q]}, :c]
  param_accessible :"o[]", :p
end
