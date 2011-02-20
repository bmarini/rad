module Rad
  class Endpoint < Struct.new(:http_method, :path, :description, :params)
    def add_param(param)
      self.params << param unless self.params.include?(param)
    end

    def add_params(params)
      params.each { |param| add_param(param) }
    end

    def to_hash
      {
        :http_method => http_method,
        :path => path,
        :description => description,
        :params => params.collect(&:to_hash)
      }
    end
  end
end