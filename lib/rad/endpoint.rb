module Rad
  class Endpoint < Struct.new(:http_method, :path, :description, :params)
    def add_param(param)
      self.params << param unless self.params.include?(param)
    end

    def add_params(params)
      params.each { |param| add_param(param) }
    end
  end
end