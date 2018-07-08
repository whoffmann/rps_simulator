class Player
  attr_accessor :health

  def initialize(health: 4)
    @health = health
  end

  def damage!(amount=1)
    @health -= amount
  end

  def defeated?
    health <= 0
  end

  def round_mutator(p1_deck, p2_deck)
  end
end
