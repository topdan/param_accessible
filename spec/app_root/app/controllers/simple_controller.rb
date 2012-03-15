class SimpleController < ApplicationController
  # TODO move action and controller up a level
  param_accessible [:foo, {:bar => [:baz, :nuts]}]
end
