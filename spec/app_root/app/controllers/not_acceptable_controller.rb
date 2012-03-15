class NotAcceptableController < ApplicationController
  include ParamAccessible::NotAcceptableHelper
  
  param_accessible :foo
  
end
