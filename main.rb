class Main
  OPTIONS = %i(attack dodge grab)
  NUM_ROUNDS = 3

  def games(p1, p2)
    deck_matchups.to_a.repeated_permutation(NUM_ROUNDS).map do |decks|
      Game.new(decks, p1.clone, p2.clone)
    end
  end

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
end

class Player
  attr_reader :health

  def initialize(health: 5)
    @health = health
  end

  def damage!(amount=1)
    @health -= amount
  end

  def defeated?
    health <= 0
  end

  def set_health(new_health)
    health = new_health
  end

  def round_mutator(p1_deck, p2_deck)
  end
end

class ForesightPlayer < Player
  def round_mutator(p1_deck, p2_deck)
    peek_card = p2_deck[0]
    unmodified_card = p1_deck[0]
    swap_card = p1_deck[1]
    if Turn.new(swap_card, peek_card).score > Turn.new(unmodified_card, peek_card).score
      p1_deck[0], p1_deck[1] = p1_deck[1], p1_deck[0]
    end
  end
end

class Game
  attr_reader :rounds, :p1, :p2

  def initialize(decks, p1, p2)
    @p1 = p1
    @p2 = p2
    @rounds = decks.map do |(p1_deck, p2_deck)|
      Round.new(p1_deck, p2_deck, p1, p2)
    end
  end

  def play
    rounds.each do |round|
      round.play
    end

    result
  end

  def result
    p1.health - p2.health
  end
end

class Round
  attr_reader :p1_deck, :p2_deck, :p1, :p2, :turns

  def initialize(p1_deck, p2_deck, p1, p2)
    @p1_deck = p1_deck
    @p2_deck = p2_deck
    @p1 = p1
    @p2 = p2

    p1.round_mutator(p1_deck, p2_deck)
    p2.round_mutator(p1_deck, p2_deck)

    @turns = p1_deck.zip(p2_deck).map do |(p1_card, p2_card)|
      Turn.new(p1_card, p2_card)
    end
  end

  def play
    turns.each do |turn|
      return if p1.defeated? || p2.defeated?
      turn.play(p1, p2)
    end
  end
end

class Turn
  attr_reader :p1_card, :p2_card

  def initialize(p1_card, p2_card)
    @p1_card = p1_card
    @p2_card = p2_card
  end

  def play(p1, p2)
    case p1_card
    when :attack
      case p2_card
      when :attack then p1.damage!; p2.damage!
      when :dodge then nil
      when :grab then p2.damage!
      end
    when :dodge
      case p2_card
      when :attack then nil
      when :dodge then nil
      when :grab then p1.damage!
      end
    when :grab
      case p2_card
      when :attack then p1.damage!
      when :dodge then p2.damage!
      when :grab then nil
      end
    end
  end

  def score
    case p1_card
    when :attack
      case p2_card
      when :attack then 0
      when :dodge then 0
      when :grab then 1
      end
    when :dodge
      case p2_card
      when :attack then 0
      when :dodge then 0
      when :grab then -1
      end
    when :grab
      case p2_card
      when :attack then -1
      when :dodge then 1
      when :grab then 0
      end
    end
  end
end

puts "Normal Players"
puts Main.new.play_games

puts "Foresight vs Normal Player"
puts Main.new.play_games(p1: ForesightPlayer.new)
