module Rad
  class Dsl
    class Base
      def self.evaluate(*args, &block)
        builder = new(*args)
        builder.instance_eval(&block)
        builder.to_definition
      end

      def to_definition
        self
      end
    end

    class Resource < Base
      attr_reader :name, :endpoints

      def initialize(name)
        @name      = name
        @endpoints = []
      end

      %w[get post put delete].each do |m|
        class_eval <<-EOF
          def #{m}(name, &block)
            add_endpoint(:#{m}, name, &block)
          end
        EOF
      end

      def add_endpoint(method, name, &block)
        @endpoints << Endpoint.evaluate(method, name, &block)
      end
    end

    class Endpoint < Base
      attr_reader :http_method, :path, :description, :params

      def initialize(http_method, path)
        @http_method = http_method
        @path        = path
        @description = ""
        @params      = []
      end

      def desc(description)
        @description = description
      end

      def param(name, &block)
        @params << Param.new(name).instance_eval(&block)
      end
    end

    class Param < Base
      def initialize(name)
        @name        = name
        @description = ""
        @required    = false
      end

      def desc(description)
        @description = description
      end

      def required
        @required = true
      end

      def type(type)
        @type = type
      end

      def allowable_values(values)
        @allowable_values = values
      end
    end

    def self.evaluate(spec)
      builder = new
      builder.instance_eval(spec)
      builder.to_definition
    end

    def initialize
      @resources = []
    end

    def resource(name, &block)
      @resources << Resource.evaluate(name, &block)
    end

    def to_definition
      Definition.new(@resources)
    end

  end
end