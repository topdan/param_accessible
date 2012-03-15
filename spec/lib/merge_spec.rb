require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MergeController do
  include RSpec::Rails::ControllerExampleGroup
  
  it "should allow a combination of all rules following the options" do
    post :create, :a => 'hi', :b => 'ho', :h => {:b => 'hey', :c => 'fo'}
    response.code.should == "200"
  end
  
  it "should not allow combinations outside of the options" do
    begin
      post :update, :a => 'hi', :b => 'ho', :h => {:b => 'hey', :c => 'fo'}
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(a h[c])
    end
  end
  
end
