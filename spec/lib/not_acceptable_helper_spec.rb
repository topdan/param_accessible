require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NotAcceptableController do
  include RSpec::Rails::ControllerExampleGroup
  
  it "should rescue_from HTML and render 406" do
    post :create, :bar => 'hi'
    response.code.should == "406"
    response.body.should include "bar is an invalid parameter"
  end
  
  it "should rescue_from json and render 406" do
    post :create, :bar => 'hi', :format => "json"
    response.code.should == "406"
    response.body.should == {:error => {:message => "You supplied invalid parameters: bar"}}.to_json
  end
  
  it "should rescue_from xml and render 406" do
    post :create, :bar => 'hi', :format => "json"
    response.code.should == "406"
    response.body.should == {:error => {:message => "You supplied invalid parameters: bar"}}.to_json
  end
  
  it "should rescue_from js and render 406" do
    post :create, :bar => 'hi', :format => "js"
    response.code.should == "406"
    response.body.should == "// invalid parameters: bar\n"
  end
  
end
