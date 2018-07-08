require_relative 'player'
require_relative 'foresight'
require_relative 'sturdy'
require_relative 'game'
require_relative 'round'
require_relative 'turn'

OPTIONS = %i(attack dodge grab)
NUM_ROUNDS = 3

def play_games(p1: Player.new, p2: Player.new)
  total = 0
  all_results = games(p1, p2).each_with_object(Hash.new(0)) do |game, result|
    game_result = game.play

    if game_result > 0
      result[:wins] += 1
    elsif game_result < 0
      result[:losses] += 1
    else
      result[:ties] += 1
    end

    total += 1
  end

  all_results.each_with_object({}) do |(key, value), percentages|
    percentages[key] = value * 100.0 / total
  end
end

def deck_matchups
  OPTIONS.permutation.to_a.repeated_permutation(2)
end

def game_permutations
  @game_permutations ||= deck_matchups.to_a.repeated_permutation(NUM_ROUNDS).to_a
end

def games(p1, p2)
  game_permutations.map do |decks|
    Game.new(decks, p1.clone, p2.clone)
  end
end

normal_player    = Player.new
foresight_player = Player.new.extend(Foresight)
sturdy_player    = Player.new.extend(Sturdy)
psychic_wall     = Player.new.extend(Foresight, Sturdy)

puts "Normal Players"
puts play_games(p1: normal_player, p2: normal_player)

puts "Foresight vs Normal Player"
puts play_games(p1: foresight_player)

puts "Sturdy Player vs Normal Player"
puts play_games(p1: sturdy_player)

puts "Foresight & Sturdy Player vs Normal Player"
puts play_games(p1: psychic_wall)

puts "Foresight vs Sturdy"
puts play_games(p1: foresight_player, p2: sturdy_player)
