module Gear
  module RulesMethods
    # Define rule for match symbol
    def match_on(obj, *args, &block)
      options = args.extract_options!

      obj = obj.to_sym

      rule = Rule.new
      rule.symbol_id   = options[:symbol_id]
      rule.symbol_name = options[:symbol_name]
      rule.multiplier  = options[:multiplier]
      rule.trigger  = options[:trigger] 
      rule.trigger_count  = options[:trigger_count] if rule.trigger.present?
      rule.block       = block

      defined_rules[obj] ||= []
      defined_rules[obj] << rule
    end

    # Currently defined rules
    def defined_rules
      @defined_rules ||= {}
    end
  end
end
