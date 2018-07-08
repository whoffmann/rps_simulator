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
