class RegexController < ApplicationController
  
  param_accessible /^foo/
  param_accessible :user => [/^bar/]
  
end
