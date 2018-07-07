class Main
  OPTIONS = %i(attack dodge grab)

  def score_all_decks
    deck_matchup_permutations.map do |(d1, d2)|
      Round.new(d1, d2).score
    end.each_with_object(Hash.new(0)) do |score, score_count|
      score_count[score] += 1
    end
  end

  def deck_matchup_permutations
    OPTIONS.permutation.to_a.repeated_permutation(2)
  end
end

class Round
  attr_reader :p1_deck, :p2_deck

  def initialize(p1_deck, p2_deck)
    @p1_deck = p1_deck
    @p2_deck = p2_deck
  end

  def score
    p1_deck.zip(p2_deck).inject(0) do |total_score, (p1_card, p2_card)|
      total_score += Turn.new(p1_card, p2_card).score
    end
  end
end

class Turn
  attr_reader :p1_card, :p2_card

  def initialize(p1_card, p2_card)
    @p1_card = p1_card
    @p2_card = p2_card
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
