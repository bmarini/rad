require 'httparty'

module Rad
  class Proxy
    def self.request(api, params)
      new(api, params).request
    end

    def initialize(api, params)
      @api         = api
      @params      = params.dup

      http_method  = @params.delete('_http_method')
      path         = @params.delete('_path')
      @endpoint    = @api.find_endpoint(http_method, path)
    end

    def http_method
      @endpoint.http_method
    end

    def path
      @path ||= @endpoint.path_params.inject(@endpoint.path.dup) do |path, param|
        path.gsub(/\{#{param.name}\}/, @params[param.name])
      end
    end

    def options
      query_params = @endpoint.query_params.inject({}) do |memo, param|
        memo.merge(param.name => @params[param.name])
      end

      { :query => query_params }
    end

    def request
      HTTParty.send(http_method, @api.domain + path, options)
    end
  end
end