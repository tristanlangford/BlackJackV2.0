class BlackJack
 # tool box methods
  def trim_name
    STDIN.gets.chomp.downcase.split(" ").join("")
  end

  def line_space
    puts "----------"
  end
  
  def ace_check
    puts "You have #{total(@player_hand)}" if @player_hand.include?("Ace") == false # Ace Check
    puts "You have #{total(@player_hand)} or #{total(@player_hand) + 10}" if @player_hand.include?("Ace") && total(@player_hand) + 10 < 22
  end

  def are_you_sure
    puts "Are you sure? Any unsaved data will be lost (Y/N)"
    input = STDIN.gets.chomp
    if input.upcase == "Y"
      return "Y"
    else
      return "N"
    end
  end

#start menu & Save/Load
  def start_menu_options
    puts "1. Play"
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
        load_game
      when "3"
        save_game
      when "9"
        exit if are_you_sure == "Y"
    end
  end

# Save game options

  def save_game
    puts "Do you want to create a new save? (Y/N)"
    input = STDIN.gets.chomp
    loop do
      if input.upcase == "Y"
        new_save
        break
      elsif input.upcase == "N"
        save_existing_game
        break
      else
        puts "Enter Y or N"
        input = STDIN.gets.chomp
      end
    end
  end

  def new_save
    puts "Enter players name"
    name = trim_name
    file = File.new("#{name}.csv", "w")
    file.puts @money
    file.close
    puts "Saved!"
    line_space
  end

  def save_existing_game
    puts "Enter players name"
    name = trim_name
    if File.exists?("#{name}.csv")
      puts "Are you sure you want to overwrite save? (Y/N)"
      if STDIN.gets.chomp.upcase == "Y"
        file = File.open("#{name}.csv", "w")
        file.puts @money
        file.close
        puts "Saved!"
        line_space
      else
      end
    elsif File.exists?("#{name}.csv") == false
      puts "Player file not located"
      line_space
    else
    end
  end

# Load Game options

  def load_game
    if are_you_sure == "Y"
      puts "Enter your name"
      name = trim_name
      if File.exists?("#{name}.csv")
        file = File.open("#{name}.csv", "r")
        file.readlines.each { |lines|
          money = lines.chomp
          @money = money.to_i
        }
        file.close
        puts "#{name} save loaded"
        line_space
        puts "You have £#{@money}"
        line_space
      else
        puts "Save does not exist"
      end
    end
  end

   # Game methods

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

# Betting Methods

  def starting_bet
    puts "You have £#{@money}"
    puts "How much to do you want to bet?"
    bet = STDIN.gets.chomp.to_i
    if @money - bet < 0
      puts "Not enough money"
      bet = STDIN.gets.input
    elsif
      bet < 2
      puts "Minimum bet is £2"
      bet STDIN.gets.input
    else
      @money -= bet
      puts "Your bet of #{bet} is accepted"
      line_space
    end
    bet
  end

  def settle_bet(bet, multiplier)
    @money += (bet * multiplier)
    puts "You now have #{@money}"
    line_space
  end

# Game flow

  def starting_hands
    @player_hand.push(random_card) until @player_hand.length == 2 # deal first 2 player cards
    puts "You're dealt a #{@player_hand[0]} and a #{@player_hand[1]}" # reveal first 2 cards
    ace_check
    
    @dealer_hand.push(random_card) until @dealer_hand.length == 2 # deal first 2 dealer cards
    line_space
    puts "Dealer has a #{@dealer_hand[0]} and another card" # reveal 1 dealer card
    line_space
  end

  def move # interative part of the game
    loop do # loop to ensure value is hit or stick
      break if total(@player_hand) == 21
      break if @player_hand.include?("Ace") && (total(@player_hand) + 10) == 21
      puts "Hit or Stick?"
      input = gets.chomp # capture hit or stick
      if input.downcase == "hit" # check for hit in any format
        @player_hand.push(random_card)
        puts "You got a #{@player_hand.last}" # notify user of their new card
        break if total(@player_hand) > 21 # check to see if bust
        ace_check
        else
          puts "You have #{total(@player_hand)}"
        end
      line_space
      elsif input.downcase == "stick" # check for stick in any format
        break
      else
        puts "Please enter Hit or Stick" # error message
      end
    end
  end

  def dealer # method for dealers turn
    puts "Dealer has a #{@dealer_hand[0]} & a #{@dealer_hand[1]}" # reveal dealer cards
    line_space
    while total(@dealer_hand) < 18 do # if over 17, dealer will stick
      break if total(@dealer_hand) > total(@player_hand)
      break if @dealer_hand.include?("Ace") && (total(@dealer_hand) + 10).between?(18, 21) # Ace Check
      @dealer_hand.push(random_card) # add new card to hand
      puts "Dealer got a #{@dealer_hand.last}" # tell player the dealers card
      if @dealer_hand.include?("Ace") && (total(@dealer_hand) + 10) < 18 # Ace Check
        puts "Dealer is on #{total(@dealer_hand)} or #{total(@dealer_hand) + 10}"
      else
        puts "Dealer is on #{total(@dealer_hand)}"
      end
    end
    line_space
  end
 
  def final(player_total, dealer_total) # method to deal with end game. take in hand scores
    puts "Player has #{player_total}, dealer has #{dealer_total}" # tell the user what each player has
    if player_total > dealer_total && dealer_total < 21 # player more than dealer
      puts "Player wins!"
      return 2
    elsif dealer_total > 21 # dealer bust
      puts "Dealer bust. Player wins!"
      return 2
    elsif dealer_total > player_total # dealer more than player
      puts "Dealer wins"
      return 0
    else
      puts "Draw"
      return 1
    end
    line_space
  end

  def end_game(bet, player_final_total)
    dealer_final_total = total(@dealer_hand)
    dealer_final_total += 10 if @dealer_hand.include?("Ace") && dealer_final_total + 10 < 22 # Ace Check
    settle_bet(bet, final(player_final_total, dealer_final_total))
  end

  def play_again
    puts "Play again? (Y/N)"
    input = STDIN.gets.chomp
    loop do
      if input.upcase == "Y"
        run_game
        break
      elsif input.upcase == "N"
        break
      else
        puts "Error: Enter Y or N"
        input = STDIN.gets.chomp
      end
    end
  end

  def run_game # method to run game
  
    bet = starting_bet

    @player_hand = [] # array for starting cards
    @dealer_hand = []

    starting_hands # Draw first 2 card

    move # initiante players moves
    player_final_total = total(@player_hand) # capture player score
    player_final_total += 10 if @player_hand.include?("Ace") && player_final_total + 10 < 22 # Ace Check

    if player_final_total > 21  # check for player bust
      puts "You are bust with #{player_final_total}"
      puts "You now have #{@money}"
      line_space
    elsif player_final_total == 21 && @player_hand.length == 2 # check to see if player starts with 21
      end_game(bet, player_final_total) # close out game
    else
      dealer #dealers move
      end_game(bet, player_final_total) # close out game
    end

    play_again  unless @money == 0 # give player option to play again unless their bust
  end

 # Bust Methods

 def bust_scenario
   puts "1. New Game"
   puts "2. Load Game"
   puts "9. Exit"
 end

 def bust_actions
   input = STDIN.gets.chomp
   case input
     when "1"
       @money = 500
     when "2"
       load_game
     when "9"
       exit
   end
 end

 # Method for launching game

 def launch
   puts "Welcome to BalckJack V2!"
   @money = 500
   loop do
     start_menu_options
     start_menu_action
     if @money == 0
       puts "You're completley BUST!"
       bust_scenario
       bust_actions
     else
     end
   end
  end

end

BlackJack.new.launch # run class & game
