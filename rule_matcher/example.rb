require_relative 'reel_screen_methods'
require_relative 'rules_methods'
require_relative 'paylines_methods'

class Array
  def extract_options!
    last.is_a?(::Hash) ? pop : {}
  end unless defined? Array.new.extract_options!
end


class Definitions
  extend Gear::RulesMethods
  extend Gear::ReelScreenMethods
  extend Gear::PaylinesMethods


  match_on :line, symbol_name: :_HIG_1_, multiplier: 600 do |line|
    line.count == 5
  end

  match_on :line, symbol_name: :_HIG_2_, multiplier: 500 do |line|
    line.count == 4
  end

  match_on :line, symbol_name: :_HIG_3_, multiplier: 400 do |line|
    line.count == 3
  end

  match_on :screen, symbol_name: :_SCA_2_, multiplier: 30, trigger: :pick_and_win, trigger_count: 1 do |screen|
    screen.count == 5
  end

  match_on :screen, symbol_name: :_SCA_2_, multiplier: 15, trigger: :pick_and_win, trigger_count: 1 do |screen|
    screen.count == 4
  end

  match_on :screen, symbol_name: :_SCA_1_, multiplier: 30, trigger: :free_game, trigger_count: 50 do |screen|
    screen.count == 5
  end

  match_on :screen, symbol_name: :_SCA_1_, multiplier: 20, trigger: :free_game, trigger_count: 20 do |screen|
    screen.count == 4
  end

  match_on :screen, symbol_name: :_SCA_1_, multiplier: 3, trigger: :free_game, trigger_count: 6 do |screen|
    screen.count == 3
  end
  
  reel_screen :rs0, width: 5, height: 3, positions: [[0,1,2],[0,1,2],[0,1,2],[0,1,2],[0,1,2]]
  #reel_screen :rs2, width: 5, height: 5, positions: [[1,2,3],[0,1,2,3,4],[0,1,2,3,4],[0,1,2,3,4],[1,2,3]]

  payline :l0, position: [0,0,0,0,0]
  payline :l1, position: [0,1,0,0,0]
  payline :l2, position: [0,2,0,0,0]
end

puts Definitions.defined_paylines
puts Definitions.defined_rules
puts Definitions.defined_reel_screens