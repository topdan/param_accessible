require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RegexController do
  include RSpec::Rails::ControllerExampleGroup
  
  it "should allow base parameters matching a regex" do
    post :create, :foo => 'hi', :foobar => 'hey'
    response.code.should == '200'
  end
  
  it "should not allow base parameters not matching a regex" do
    begin
      post :create, :nuts => "hi"
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(nuts)
    end
  end
  
  it "should allow nested parameters matching the regex" do
    post :create, :user => {:bar => 'hi', :bar_me => 'hey'}
    response.code.should == '200'
  end
  
  it "should not allow nested parameters not matching a regex" do
    begin
      post :create, :user => {:nuts => "hi"}
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(user[nuts])
    end
  end
  
end
