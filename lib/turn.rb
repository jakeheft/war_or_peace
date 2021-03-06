class Turn

  attr_reader :player1, :player2, :spoils_of_war, :og_type


  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @spoils_of_war = []
    @og_type = :basic
    @player1_top_card = @player1.deck.rank_of_card_at(0)
    @player2_top_card = @player2.deck.rank_of_card_at(0)
    @player1_third_card = @player1.deck.rank_of_card_at(2)
    @player2_third_card = @player2.deck.rank_of_card_at(2)
  end

  def type
    if @player1_top_card == @player2_top_card && @player1_third_card == @player2_third_card
      @og_type = :mutually_assured_destruction
      :mutually_assured_destruction
    elsif @player1_top_card == @player2_top_card
      @og_type = :war
      :war
    elsif @player1_top_card != @player2_top_card
      @og_type = :basic
      :basic
    end
  end


  def winner
    if type == :basic
      if @player1_top_card > @player2_top_card
        @player1
      else
        @player2
      end
    elsif type == :war
      if @player1_third_card > @player2_third_card
        @player1
      else
        @player2
      end
    elsif type == :mutually_assured_destruction
      "No Winner"
    end
  end

  def collect_spoils(player)
    @spoils_of_war << player.deck.remove_card
    @spoils_of_war = @spoils_of_war.shuffle
  end

  def pile_cards
    if type == :war
      [@player1, @player2].each do |player|
        3.times { collect_spoils(player) }
      end
    elsif type == :basic
      [@player1, @player2].each do |player|
        collect_spoils(player)
      end
    elsif type == :mutually_assured_destruction
      [@player1, @player2].each do |player|
        3.times { player.deck.remove_card }
      end
    end
  end

  def award_spoils(winner)
    winner.deck.cards = winner.deck.add_card(@spoils_of_war).flatten
  end

end
