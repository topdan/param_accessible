require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UnlessTrueController do
  include RSpec::Rails::ControllerExampleGroup
  
  it "should not allow the attribute" do
    begin
      post :create, :foo => "hi"
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(foo)
    end
  end
  
  it "should not allow the nested attribute" do
    begin
      post :create, :bar => {:baz => "hi"}
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(bar)
    end
  end
  
end
