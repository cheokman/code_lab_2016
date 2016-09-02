require_relative 'payline'
module Gear
  module PaylinesMethods
    def payline(name, *args)
      options = args.extract_options!

      payline = Payline.new
      payline.name = name
      payline.scope = options[:scope]
      payline.positions = options[:positions]

      defined_paylines << payline
    end

    def defined_paylines
      @defined_paylines ||= []
    end
  end
end