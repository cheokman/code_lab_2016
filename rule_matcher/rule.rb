module Gear
  # Rules has a symbol name, a target to symbol, a conditions block
  # and a temporary option.
  class Rule
    attr_accessor :symbol_id, :symbol_name, :count, :multiplier, :block

    # Does this rule's condition block apply?
    def applies?(target_obj = nil)
      return true if block.nil? # no block given: always true

      case block.arity
      when 1 # Expects target object
        if target_obj.present?
          block.call(target_obj)
        else
          puts '[gear] no target_obj found on Rule#applies?'
          false
        end
      when 0
        block.call
      end
    end
  end
end
