module Rad
  class Definition < Struct.new(:domain, :resources)
    def to_json
      resources.collect(&:to_hash).to_json
    end

    def find_endpoint(http_method, path)
      resources.
        inject([]) { |m,r| m + r.endpoints }.
        detect { |e| e.http_method == http_method.to_sym && e.path == path }
    end
  end
end