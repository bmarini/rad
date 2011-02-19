module Rad
  class Dsl
    class Base
      def self.evaluate(*args, &block)
        builder = new(*args)
        builder.instance_eval(&block)
        builder.to_definition
      end

      class << self
        def property(*names)
          names.each do |name|
            define_method name do |value|
              instance_variable_set("@#{name}", value)
            end
          end
        end
      end

      def to_definition
        self
      end
    end

    module Params
      def param(name, &block)
        @params << Param.evaluate(name, &block)
      end

      def required_param(name, &block)
        param = Param.evaluate(name, &block)
        param.required = true
        @params << param
      end
    end

    class Resource < Base
      attr_reader :name, :endpoints
      include Params

      def initialize(name)
        @name      = name
        @endpoints = []
        @params    = []
      end

      %w[get post put delete].each do |m|
        class_eval <<-EOF
          def #{m}(name, &block)
            add_endpoint(:#{m}, name, &block)
          end
        EOF
      end

      def add_endpoint(method, name, &block)
        endpoint = Endpoint.evaluate(method, name, &block)

        @params.each do |param|
          # Add global params at the end unless they are defined already
          unless endpoint.params.detect { |p| p.name == param.name }
            endpoint.params << param
          end
        end

        @endpoints << endpoint
      end

      def to_definition
        Rad::Resource.new(@name, @endpoints)
      end
    end

    class Endpoint < Base
      include Params
      property :desc

      def initialize(http_method, path)
        @http_method = http_method
        @path        = path
        @desc        = ""
        @params      = []
      end

      def to_definition
        Rad::Endpoint.new(@http_method, @path, @desc, @params)
      end
    end

    class Param < Base
      property :desc, :type, :allowable_values

      def initialize(name)
        @name        = name
        @desc        = ""
        @required    = false
      end

      def to_definition
        Rad::Param.new(@name, @desc, @type, @required, @allowable_values)
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