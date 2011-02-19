module Rad
  class Param < Struct.new(:name, :description, :param_type, :required, :allowable_values)

    def required?
      @required
    end
  end
end