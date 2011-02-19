module Rad
  class Param < Struct.new(:name, :description, :param_type, :required, :allowable_values)

    def required?
      @required
    end

    def <=>(other)
      self.name == other.name
    end
  end
end