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

This gem does not add any functionality by default. To activate it create a before_filter in any ActionController::Base subclass. We only use the filter for create and update actions because those are the normally only the only harmful ones:

    before_filter :ensure_params_are_accessible, :only => [:create, :update]

Now let's expose the parameters that are common across our application:

    param_accessible :page, :sort

You may want to allow all base-level parameters since most Rails controllers only send nested parameters to models (i.e. params[:user]):

    # allow all base parameters (// is a regex that matches all strings)
    param_accessible //
    
    # allow any base parameter starting with "my_"
    param_accessible /^my_/

We also want to make sure only admins can change a user's "is_admin" and "is_active" attributes:

    param_accessible :user => [:is_admin, :is_active], :if => :is_admin?

Rinse and repeat for all your controllers and you're Rails Application will be much safer.

## Example

Placing the before_filter in our ApplicationController makes all our create and update actions secure by default. We also expose application-wide parameters and provide a friendly error message when an invalid parameter is provided.

    class ApplicationController < ActionController::Base
      
      # make all your controllers secure by default
      before_filter :ensure_params_are_accessible, :only => [:create, :update]
      
      # expose the your common application parameters
      param_accessible :page, :sort
      
      # this error is thrown when the user submits an inaccessible param
      rescue_from ParamAccessible::Error, :with => :handle_param_not_accessible
      
      protected
      
      def handle_param_not_accessible e
        flash[:error] = "You gave me some invalid parameters: #{e.inaccessible_params.join(', ')}"
        redirect_to :back
      end
      
    end

Inheriting from the class above, we now need to specify our accessible parameters for the create and update actions.

    class UsersController < ApplicationController
      
      # these attributes are available for everyone
      param_accessible :user => [:name, :email, :password, :password_confirmation]
      
      # these attributes are only available if the controller instance method is_admin? is true
      param_accessible :user => [:is_admin, :is_locked_out], :if => :is_admin?
      
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

Showcase a helper module for handling errors and some more options.

    class DemoController < ApplicationController
      
      # rescue_from ParamAccessible::Error and respond with a 406 Not Acceptable status 
      # with an HTML, JSON, XML, or JS explanation of which parameters were invalid
      include ParamAccessible::NotAcceptableHelper
      
      param_accessible :foo, :if => :is_admin
      param_accessible :bar, :unless => :logged_in?
      param_accessible :baz, :only => :show
      param_accessible :nut, :except => :index
      
    end

Using Rails' skip_before_filter to make a controller insecure again

    class InsecureController < ApplicationController
      
      # skip the filter ApplicationController set up to avoid the accessible parameter checks
      skip_before_filter :ensure_params_are_accessible
      
    end

## TODO

* Mark a parameter that expects an array as its value:
  * param_accessible :user => ["group_ids[]"]
    * would accept [10,12] or {"0" => 10, "1" => 12}
  * param_accessible :user => {"groups[]" => [:name]}
    * would accept [{:name => "Admins"}, {:name => "Users"}]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
