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
