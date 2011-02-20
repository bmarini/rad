module Rad
  class Definition < Struct.new(:resources)
    def to_json
      resources.collect(&:to_hash).to_json
    end
  end
end