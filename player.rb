class Player
  attr_reader :health

  def initialize(health: 4)
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
