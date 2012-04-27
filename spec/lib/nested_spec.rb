require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NestedController do
  include RSpec::Rails::ControllerExampleGroup

  it "should allow arrays given as rails style pseudo hashes" do
    post :create, :a => { :b => {"0" => {"d"=>"foo", "e"=>"bar"}, "1" => {"d"=>"foo", "e"=>"bar"}}}
    response.code.should == "200"
  end

  it "should allow arrays given as arrays hashes" do
    post :create, :a => { :b => [{"d"=>"foo", "e"=>"bar"}, {"d"=>"foo", "e"=>"bar"}]}
    response.code.should == "200"
  end

  it "should allow arrays given as arrays hashes" do
    post :create, :o => ["foo", "bar"]
    response.code.should == "200"
  end

  it "should allow arrays given as rails style hash arrays when only arrays of strings are allowed" do
    post :create, :o => { "0" => "foo", "1" => "bar" }
    response.code.should == "200"
  end

  it "should not allow options which are not in the list" do
    begin
      post :create, :a => { :b => {"0" => {"x"=>"foo" }}}
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(a[b][0][x])
    end
  end

  it "should not allow strings for an array" do
    begin
      post :create, :a => { :b => "foo" }
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(a[b])
    end
  end

  it "should not allow arrays with invalid values" do
    begin
      post :create, :a => { :b => [{"x"=>"foo"}]}
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(a[b][][x])
    end
  end

  it "should not allow arrays with invalid values at other index" do
    begin
      post :create, :a => { :b => [{"d" => "foo"}, {"x"=>"foo"}]}
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(a[b][][x])
    end
  end

  it "should not allow hashes when only arrays of strings are allowed" do
    begin
      post :create, :o => [{ :foo => "bar" }]
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(o[][foo])
    end
  end

  it "should not allow string when only arrays are allowed" do
    begin
      post :create, :o => "foo"
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(o)
    end
  end

  it "should not allow arrays given as rails style hash arrays containing hashes when only arrays of strings are allowed" do
    begin
      post :create, :o => { "0" => { "x" => "foo" } }
      raise "should fail"
    rescue ParamAccessible::Error => e
      e.inaccessible_params.should == %w(o[0][x])
    end
  end
end
