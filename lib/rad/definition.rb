module Rad
  class Definition
    attr_accessor :resources

    def initialize(resources)
      @resources = resources
    end
  end
end