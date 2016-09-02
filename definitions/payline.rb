module Gear
  class Payline
    SCOPE_MAPPING = {
      left_to_right: 0,
      right_to_left: 1,
      any: 2
    }

    attr_accessor :name, :scope, :positions
    
    def scope=(value)
      _scope = (value || :left_to_right).to_sym
      @scope = SCOPE_MAPPING.fetch(_scope, SCOPE_MAPPING[:left_to_right])
    end

    def scope
      SCOPE_MAPPING.key(@scope)
    end
  end
end