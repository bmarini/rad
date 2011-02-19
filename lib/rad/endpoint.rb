module Rad
  class Endpoint < Struct.new(:http_method, :path, :description, :params)
  end
end