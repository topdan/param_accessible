require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IfTrueController do
  include RSpec::Rails::ControllerExampleGroup
  
  it "should allow valid attributes" do
    post :create, :foo => "hi"
    response.code.should == "200"
  end
  
  it "should disallow invalid attributes" do
    begin
      post :create, :nuts => "hi"
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(nuts)
    end
  end
  
  it "should allow valid nested attributes" do
    post :update, :bar => {:baz => 'hi'}
    response.code.should == "200"
  end
  
  it "should disallow invalid nested attributes" do
    begin
      post :update, :bar => {:foo => 'hi'}
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(bar[foo])
    end
  end
  
end
