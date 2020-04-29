class BlackJack
def random_card
  cards = [
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine",
    "Ten",
    "Jack",
    "Queen",
    "King",
    "Ace"
  ]
  cards[rand(13)]
end

def total(hand)
  hand_total = 0
  cards = {
    "Two" => 2,
    "Three" => 3,
    "Four" => 4,
    "Five" => 5,
    "Six" => 6,
    "Seven" => 7,
    "Eight" => 8,
    "Nine" => 9,
    "Ten" => 10,
    "Jack" => 10,
    "Queen" => 10,
    "King" => 10,
    "Ace" => 11
  }
  hand.each{ |card|
  hand_total += cards[card]
  }
  hand_total
end

def move(current_hand)
  hand = current_hand
  puts "Hit or Stick?"
  loop do
    input = gets.chomp
    if input.downcase == "hit"
      hand.push(random_card)
      running_total = total(hand)
      break if running_total > 21
      puts "You have #{running_total}"
      puts "Hit or Stick?"
    elsif input.downcase == "stick"
      break
    else
      puts "Please enter Hit or Stick"
    end
  end
  hand
end

def final(player, dealer)
  puts "Player has #{player}, dealer has #{dealer}"
  if player > dealer && dealer < 21
    puts "Player wins!"
  elsif dealer > 21
    puts "Dealer bust. Player wins!"
  elsif dealer > player
    puts "Dealer wins"
  else
    puts "Draw"
  end
end

def dealer(dealers_hand)
  dealers_final_hand = dealers_hand
  dealer_running_total = total(dealers_hand)
  puts "Dealer has a #{dealers_final_hand[0]} & a #{dealers_final_hand[1]}"
  while dealer_running_total < 18 do
    dealers_final_hand.push(random_card)
    puts "Dealer got a #{dealers_final_hand.last}"
    dealer_running_total = total(dealers_final_hand)
    puts "Dealer is on #{dealer_running_total}"
  end
  dealer_total = total(dealers_final_hand)
end

def run_game
  puts "Welcome to BlackJack"
  
  player_hand = []
  dealer_hand = []
  
  player_hand.push(random_card) while player_hand.length < 2
  puts "You're dealt a #{player_hand[0]} and a #{player_hand[1]}"
  starting_total = total(player_hand)
  puts "You have #{starting_total}"
  dealer_hand.push(random_card) while dealer_hand.length < 2
  puts "Dealer has a #{dealer_hand[0]} and another card"
  
  player_hand = move(player_hand)
  player_total = total(player_hand)
  
  puts "You are bust with #{player_total}" if player_total > 21  
 
  dealer_total = dealer(dealer_hand) if player_total < 22
  final(player_total, dealer_total) if player_total < 22
end
end
BlackJack.new.run_game
