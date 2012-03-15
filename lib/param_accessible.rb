require "param_accessible/version"
require "param_accessible/error"
require "param_accessible/rule"
require "param_accessible/rules"
require "param_accessible/not_acceptable_helper"
require "param_accessible/controller_ext"

ActionController::Base.send(:include, ParamAccessible::ControllerExt)
