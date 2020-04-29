class BlackJack

=begin
Ace Check: If someone has an ace, check if making it 11 would make them bust
or not. If not reveal both possible hand values. At end game, return highest value
as long as its not above 21.
=end

def random_card #method to return a random card
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

def total(hand)  # method to calc current hand total
  hand_total = 0
  cards = { # hash of all values
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
    "Ace" => 1
  }
  hand.each{ |card|
  hand_total += cards[card] # adds value of each card to total
  }
  hand_total # return total
end

def move(current_hand) # interative part of the game
  hand = current_hand # take current hand and make it updatable
  puts "Hit or Stick?"
  loop do # loop to ensure value is hit or stick
    input = gets.chomp # capture hit or stick
    if input.downcase == "hit" # check for hit in any format
      new_card = random_card 
      hand.push(new_card) # issue new card and add to hand
      puts "You got a #{new_card}" # notify user of their new card
      running_total = total(hand) # get new total of hand
      break if running_total > 21 # check to see if bust
      if hand.include?("Ace") && (running_total + 10) < 21 # Ace check
        puts "You have #{running_total} or #{running_total + 10}"
      else      
        puts "You have #{running_total}"
        puts "Hit or Stick?"
      end
    elsif input.downcase == "stick" # check for stick in any format
      break
    else
      puts "Please enter Hit or Stick" # error message
    end
  end
  hand # return the hand
end

def final(player, dealer) # method to deal with end game. take in hand scores
  puts "Player has #{player}, dealer has #{dealer}" # tell the user what each player has
  if player > dealer && dealer < 21 # player more than dealer
    puts "Player wins!"
  elsif dealer > 21 # dealer bust
    puts "Dealer bust. Player wins!"
  elsif dealer > player # dealer more than player
    puts "Dealer wins"
  else
    puts "Draw" # draw
  end
end

def dealer(dealers_hand) # method for dealers turn
  dealers_final_hand = dealers_hand # take dealers first 2 cards and make new hand var
  dealer_running_total = total(dealers_hand) # calculate current hand total
  puts "Dealer has a #{dealers_final_hand[0]} & a #{dealers_final_hand[1]}" # reveal dealer cards
  while dealer_running_total < 18 do # if over 17, dealer will stick
    if dealers_final_hand.include?("Ace") && (dealer_running_total + 10).between?(18, 21) # Ace Check
      break
    else  
      dealers_final_hand.push(random_card) # add new card to hand
      puts "Dealer got a #{dealers_final_hand.last}" # tell player the dealers card
      dealer_running_total = total(dealers_final_hand) # update dealers total
      if dealers_final_hand.include?("Ace") && (dealer_running_total + 10) < 18 # Ace Check
        puts "Dealer is on #{dealer_running_total} or #{dealer_running_total + 10}" 
      else 
        puts "Dealer is on #{dealer_running_total}"
      end
    end
  end
  total(dealers_final_hand) # return hand value
end

def run_game # method to run game
  puts "Welcome to BlackJack" # intro
  
  player_hand = [] # array for starting cards
  dealer_hand = []
  
  player_hand.push(random_card) while player_hand.length < 2 # deal first 2 player cards
  puts "You're dealt a #{player_hand[0]} and a #{player_hand[1]}" # reveal first 2 cards
  starting_total = total(player_hand)
  puts "You have #{starting_total}" if player_hand.include?("Ace") == false # Ace Check
  puts "You have #{starting_total} or #{starting_total + 10}" if player_hand.include?("Ace")
  dealer_hand.push(random_card) while dealer_hand.length < 2 # deal first 2 dealer cards
  puts "Dealer has a #{dealer_hand[0]} and another card" # reveal 1 dealer card
  
  player_hand = move(player_hand) # initiante players moves
  player_total = total(player_hand) # capture player score
  player_total += 10 if player_hand.include?("Ace") && player_total + 10 < 22 # Ace Check
  
  puts "You are bust with #{player_total}" if player_total > 21  # check for player bust
 
  dealer_total = dealer(dealer_hand) # dealer only goes if player not bust
  final(player_total, dealer_total) if player_total < 22 # run end game
end
end
BlackJack.new.run_game # run class & game
