require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SimpleController do
  include RSpec::Rails::ControllerExampleGroup
  
  it "should not complain if the attributes are missing" do
    post :create
    response.code.should == "200"
  end
  
  it "should not complain about common rails parameters" do
    post :update, :format => "json", :id => "foo"
    response.code.should == "200"
  end
  
  it "should not complain if a subset of those attributes are given" do
    post :create, :foo => 'hi'
    response.code.should == "200"
  end
  
  it "should not complain if exactly those attributes are given" do
    post :create, :foo => 'hi', :bar => {:baz => 'hey', :nuts => 'ho'}
    response.code.should == "200"
  end
  
  it "should not complain on actions outside of the before_filter" do
    get :show, :unknown => 'hi'
    response.code.should == '200'
  end
  
  it "should complain an unknown attribute is given" do
    begin
      post :create, :unknown => 'hi'
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(unknown)
    end
  end
  
  it "should complain an unknown nested attribute is given" do
    begin
      post :create, :bar => {:unknown => 'hi'}
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(bar[unknown])
    end
  end

  it "should be fine when the ONLY value is a value but not an options hash" do
    SimpleController.param_accessible :bar => []
  end
  
  it "should raise an error when the last value is a hash, but not an options hash" do
    lambda { SimpleController.param_accessible :foo, :bar => [] }.should raise_error(ArgumentError)
  end
  
end
