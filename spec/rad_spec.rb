require 'spec_helper'

class TestRad < MiniTest::Spec
  describe "Rad::Dsl" do
    before do
      @rad = Rad::Dsl.evaluate( File.read( File.expand_path("../fixtures/Radfile", __FILE__) ) )
    end

    it "is wired up" do
      @rad.must_be_instance_of Rad::Definition
    end

    it "defines a resource" do
      resource = @rad.resources.first

      resource.name.must_equal :accounts
      resource.endpoints.must_respond_to :each
    end

    it "defines an endpoint" do
      endpoint = @rad.resources.first.endpoints.first

      endpoint.http_method.must_equal :get
      endpoint.path.must_equal "/accounts/authenticate/{username}.{format}"
      endpoint.description.must_equal "Authenticates a User"
    end

    it "defines some params" do
      params = @rad.resources.first.endpoints.first.params
      params.must_respond_to :each
      params.first.must_be_instance_of Rad::Param

      username_param = params.first
      username_param.name.must_equal :username
      username_param.param_type.must_equal :path
      username_param.description.must_equal "The user's username"
    end

    it "defines a global param" do
      params = @rad.resources.first.endpoints.first.params
      params.last.name.must_equal :format
    end
  end
end