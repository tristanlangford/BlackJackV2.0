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

def move # interative part of the game
  puts "Hit or Stick?"
  loop do # loop to ensure value is hit or stick
    input = gets.chomp # capture hit or stick
    if input.downcase == "hit" # check for hit in any format
      @player_hand.push(random_card)
      puts "You got a #{@player_hand.last}" # notify user of their new card
      running_total = total(@player_hand) # get new total of hand
      break if running_total > 21 # check to see if bust
      if @player_hand.include?("Ace") && (running_total + 10) < 21 # Ace check
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
end

def final(player_total, dealer_total) # method to deal with end game. take in hand scores
  puts "Player has #{player_total}, dealer has #{dealer_total}" # tell the user what each player has
  if player_total > dealer_total && dealer_total < 21 # player more than dealer
    puts "Player wins!"
  elsif dealer_total > 21 # dealer bust
    puts "Dealer bust. Player wins!"
  elsif dealer_total > player_total # dealer more than player
    puts "Dealer wins"
  else
    puts "Draw"
  end
end

def dealer # method for dealers turn
  puts "Dealer has a #{@dealer_hand[0]} & a #{@dealer_hand[1]}" # reveal dealer cards
  while total(@dealer_hand) < 18 do # if over 17, dealer will stick
    break if total(@dealer_hand) > total(@player_hand)
    if @dealer_hand.include?("Ace") && (total(@dealer_hand) + 10).between?(18, 21) # Ace Check
      break
    else  
      @dealer_hand.push(random_card) # add new card to hand
      puts "Dealer got a #{@dealer_hand.last}" # tell player the dealers card
      if @dealer_hand.include?("Ace") && (total(@dealer_hand) + 10) < 18 # Ace Check
        puts "Dealer is on #{total(@dealer_hand)} or #{total(@dealer_hand) + 10}" 
      else 
        puts "Dealer is on #{total(@dealer_hand)}"
      end
    end
  end
end

def starting_hands
  @player_hand.push(random_card) until @player_hand.length == 2 # deal first 2 player cards
  puts "You're dealt a #{@player_hand[0]} and a #{@player_hand[1]}" # reveal first 2 cards
  
  puts "You have #{total(@player_hand)}" if @player_hand.include?("Ace") == false # Ace Check
  puts "You have #{total(@player_hand)} or #{total(@player_hand) + 10}" if @player_hand.include?("Ace")
  @dealer_hand.push(random_card) until @dealer_hand.length == 2 # deal first 2 dealer cards
  puts "Dealer has a #{@dealer_hand[0]} and another card" # reveal 1 dealer card
end

def run_game # method to run game
  puts "Welcome to BlackJack" # intro
  
  @player_hand = [] # array for starting cards
  @dealer_hand = []
  
  starting_hands
  
  move # initiante players moves
  player_final_total = total(@player_hand) # capture player score
  player_final_total += 10 if @player_hand.include?("Ace") && player_final_total + 10 < 22 # Ace Check
  
  if player_final_total > 21  # check for player bust
    puts "You are bust with #{player_final_total}"
  else
    dealer
    dealer_final_total = total(@dealer_hand)
    dealer_final_total += 10 if @dealer_hand.include?("Ace") && dealer_final_total + 10 < 22 # Ace Check
    final(player_final_total, dealer_final_total) if player_final_total < 22 # run end game
  end
  
  play_again
end

def play_again
  puts "Play again? (Y/N)"
  input = STDIN.gets.chomp
  loop do 
    if input.upcase == "Y"
      run_game
    elsif input.upcase == "N"
      break
    else
      puts "Error: Enter Y or N"
      input = STDIN.gets.chomp
    end
  end
end

def start_menu_options
  puts "1. New Game"
  puts "2. Load Game"
  puts "3. Save Game"
  puts "9. Exit"
end

def start_menu_action
  input = STDIN.gets.chomp
  case input
    when "1"
      run_game
    when "2"
      puts "Feature coming soon!"
    when "3"
      puts "Feature coming soon!"
    when "9"
      exit
  end
end

def play
  loop do
    start_menu_options
    start_menu_action
  end
end

end
        
BlackJack.new.play # run class & game
