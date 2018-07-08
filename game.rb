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
