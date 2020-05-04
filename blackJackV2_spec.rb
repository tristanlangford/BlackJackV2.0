require "./blackJackV2.rb"

RSpec.describe 'BlackJack' do
 
  context "Counting players hand" do
    it 'counts cards correctly' do
      hand = ["Jack", "Eight", "Two", "Seven", "King"]
      result = BlackJack.new.total(hand)
      expect(result).to eq(37)
    end
  end

  context "outcomes" do
    it "outputs correct outcome" do
      player = 20
      dealer = 19
      result = BlackJack.new.final(player, dealer)
      expect(result). to eq(2)
   end
  end
end
