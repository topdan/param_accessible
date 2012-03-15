require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ExceptController do
  include RSpec::Rails::ControllerExampleGroup
  
  it "should limit those attribute to ONLY those actions" do
    post :update, :foo => "hi"
    response.code.should == "200"
  end
  
  it "should disallow unknown attributes from those actions" do
    begin
      post :update, :bar => "hi"
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(bar)
    end
  end
  
  it "should obey nested attributes" do
    post :create, :bar => {:baz => 'hi'}
    response.code.should == "200"
  end
  
  it "should catch invalid nested attributes for those actions" do
    begin
      post :create, :bar => {:foo => 'hi'}
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(bar[foo])
    end
  end
  
end
