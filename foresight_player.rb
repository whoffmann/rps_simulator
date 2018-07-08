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
