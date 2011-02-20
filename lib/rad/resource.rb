module Rad
  class Resource < Struct.new(:name, :endpoints)
    def to_hash
      {
        :name => name,
        :endpoints => endpoints.collect(&:to_hash)
      }
    end
  end
end