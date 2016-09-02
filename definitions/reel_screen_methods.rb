require_relative 'reel_screen'
module Gear
  module ReelScreenMethods
    def reel_screen(name, *args)
      named = name.to_sym
      options = args.extract_options!

      reel_screen = ReelScreen.new
      reel_screen.width = options.fetch(:width, 5)
      reel_screen.height = options.fetch(:height, 3)
      reel_screen.positions = options[:positions]

      defined_reel_screens[named] = reel_screen
    end

    def defined_reel_screens
      @defined_reel_screens ||= {}
    end
  end
end