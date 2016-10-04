module Axle
  class Game
    extend Options

    accept_options :observers

    observers [GameEngine, Gamebox]
    
    attr_reader :name

    def self.build(id)

      new(id)
    end

    def initialize(name, opts={})
      @name = name
    end

  end
end