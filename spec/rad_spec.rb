require 'spec_helper'

class TestRAD < MiniTest::Spec
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
      endpoint.path.must_equal "/accounts/authenticate/{username}"
      endpoint.description.must_equal "Authenticates a User"
    end

    it "defines some params" do
      params = @rad.resources.first.endpoints.first.params
      params.must_respond_to :each
    end
  end
end