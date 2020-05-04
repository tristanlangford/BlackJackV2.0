require "./blackJackV2.rb"

RSpec.describe 'BlackJack' do
 
  context "Counting players hand" do
    it 'counts cards correctly' do
      hand = ["Jack", "Eight", "Two", "Seven", "King"]
      result = BlackJack.new.total(hand)
      expect(result).to eq(37)
    end
  end

  context "Settle bet" do
    it 'settles bet correctly' do
      bet = 50
      multiplier = 2
      result = BlackJack.new.settle_bet(bet, multiplier)
      expect(result).to eq(600)
    end
  end

end
