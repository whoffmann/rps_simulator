require_relative 'player'
require_relative 'foresight'
require_relative 'sturdy'

class PlayerBuilder
  def self.build
    builder = new
    yield builder if block_given?
    builder.player
  end

  attr_reader :player

  def initialize
    @player = Player.new
  end

  def set_health(health)
    @player.health = health
  end

  def set_sturdy
    @player.extend(Sturdy)
  end

  def set_foresight
    @player.extend(Foresight)
  end
end
