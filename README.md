# ParamAccessible

[![Build Status](https://secure.travis-ci.org/topdan/param_accessible.png)](https://secure.travis-ci.org/topdan/param_accessible.png)

Provides a method to help protect your Ruby on Rails controllers from malicious or accidentally destructive user parameters. It is independent, but heavily influenced by param_protected.

Make all your controllers secure by default as well as provide readable messages to users when a security breach was prevented.

For more information on the design considerations please visit: https://www.topdan.com/ruby-on-rails/params-accessible.html

## Installation

Add this line to your application's Gemfile:

    gem 'param_accessible'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install param_accessible

## Usage

    class ApplicationController < ActionController::Base
      
      # make all your controllers secure by default
      before_filter :ensure_params_are_accessible, :only => [:create, :update]
      
      # expose the common rails parameters
      param_accessible :controller, :action, :format, :id
      
      # this error is thrown when the user tries to access an inaccessible param
      rescue_from ParamAccessible::Error, :with => :handle_param_not_accessible
      
      protected
      
      def handle_param_not_accessible e
        flash[:error] = "You gave me some invalid parameters: #{e.inaccessible_params.join(', )}"
        redirect_to :back
      end
      
    end
    
    class UserController < ApplicationController
      
      # these attributes are available for everyone
      param_accessible :user => {:name, :email, :password, :password_confirmation}
      
      # these attributes are only available if the controller instance method is_admin? is true
      param_accessible :user => {:is_admin, :is_locked_out}, :if => :is_admin?
      
      def update
        @user = User.find(params[:id])
        
        # this is now safe!
        if @user.update_attributes(params[:user])
          ...
        else
          ...
        end
      end
    end
    
    class DemoController < ApplicationController
      
      # rescue_from ParamAccessible::Error and respond with a 406 Not Acceptable status 
      # with an HTML, JSON, XML, or JS explanation of which parameters were invalid
      include ParamAccessible::NotAcceptableHelper
      
      param_accessible :foo, :if => :is_admin
      param_accessible :bar, :unless => :logged_in?
      param_accessible :baz, :only => :show
      param_accessible :nut, :except => :index
      
    end
    
    class InsecureController < ApplicationController
      
      # skip the filter ApplicationController set up to avoid the accessible parameter checks
      skip_before_filter :ensure_params_are_accessible
      
    end
    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request