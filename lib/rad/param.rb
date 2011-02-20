module Rad
  class Param < Struct.new(:name, :description, :param_type, :required, :allowable_values)

    def required?
      @required
    end

    def <=>(other)
      self.name == other.name
    end

    def to_hash
      {
        :name => name,
        :description => description,
        :param_type => param_type,
        :required => required,
        :allowable_values => allowable_values
      }
    end
  end
end