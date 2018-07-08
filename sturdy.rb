module Sturdy
  def round_mutator(p1_deck, p2_deck)
    super(p1_deck, p2_deck)

    if @health == 1
      @health = 2
    end
  end
end
