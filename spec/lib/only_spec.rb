require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe OnlyController do
  include RSpec::Rails::ControllerExampleGroup
  
  it "should limit those attribute to ONLY those actions" do
    post :create, :foo => "hi"
    response.code.should == "200"
  end
  
  it "should disallow unknown attributes from those actions" do
    begin
      post :create, :bar => "hi"
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(bar)
    end
  end
  
  it "should obey nested attributes" do
    post :update, :bar => {:baz => 'hi'}
    response.code.should == "200"
  end
  
  it "should catch invalid nested attributes for those actions" do
    begin
      post :update, :bar => {:foo => 'hi'}
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(bar[foo])
    end
  end
  
end
