class MyRule
  include Gear::RulesMethods

  match_on :line, symbol_name: :_HIG_1, multiplier: 600 do |line|
    line.count == 5
  end

  match_on :line, symbol_name: :_HIG_2, multiplier: 500 do |line|
    line.count == 4
  end

  match_on :line, symbol_name: :_HIG_3, multiplier: 400 do |line|
    line.count == 3
  end

  match_on :screen, symbol_name: :_SCA_2, multiplier: 30, trigger: :pick_and_win, trigger_count: 1 do |screen|
    screen.count == 5
  end

  match_on :screen, symbol_name: :_SCA_2, multiplier: 15, trigger: :pick_and_win, trigger_count: 1 do |screen|
    screen.count == 4
  end

  match_on :screen, symbol_name: :_SCA_1, multiplier: 30, trigger: :free_game, trigger_count: 50 do |screen|
    screen.count == 5
  end

  match_on :screen, symbol_name: :_SCA_1, multiplier: 20, trigger: :free_game, trigger_count: 20 do |screen|
    screen.count == 4
  end

  match_on :screen, symbol_name: :_SCA_1, multiplier: 3, trigger: :free_game, trigger_count: 6 do |screen|
    screen.count == 3
  end


end