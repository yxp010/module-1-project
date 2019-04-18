class BattleShip < Game



  def start(user)

    new_board = self.board
    puts "Let's play Battleship!\n-----\nYou have 10 tries!\n-----"
    self.print_board(self.board)

    the_ship_row = self.ship_row
    the_ship_col = self.ship_col
    # binding.pry
    turn = 1
    while turn <= 10
      puts "Turn: #{turn}"
      puts Paint["Press Enter to leave the game", :red, :bright]
      guess_row = $prompt.ask("Guess Row (1-10): ")


      while guess_row.to_i > 10 || guess_row.to_i < 1
        if guess_row == nil
          turn = 10
          break
        end
        puts Paint['Please enter a valid number.', :red, :bright]
        guess_row = $prompt.ask("Guess Row (1-10): ")
      end
      if guess_row != nil
        guess_col = $prompt.ask("Guess Collumn (1-10): ")
        while guess_col.to_i > 10 || guess_col.to_i < 1
          if guess_col == nil
            turn = 10
            break
          end
          puts Paint['Please enter a valid number.', :red, :bright]
          guess_col = $prompt.ask("Guess Collumn (1-10): ")
        end
      end

      if turn == 10
        puts "------\nGame Over!\nThe Battleship coordinates were:#{the_ship_row},#{the_ship_col}"
        puts 'You lost 200 points'
        user.points -= 200
        self.result('L', user)
        break
      elsif (guess_row == the_ship_row) && (guess_col == the_ship_col)
        puts "Congratulations! You sunk my battleship!"
        puts 'You won 400 points'
        user.points += 400
        self.result('W', user)
        break
      else
        # if ((guess_row < 0) || (guess_row > 9)) || ((guess_col < 0) || (guess_col > 9))
        #     puts "Oops, that's not even in the ocean."
        if (new_board[guess_row.to_i - 1][guess_col.to_i - 1] == "X")
            puts "You guessed that one already."
        else
            puts "You missed my battleship!"
            new_board[guess_row.to_i - 1][guess_col.to_i - 1] = Paint["X", :red, :bright]
        end
        puts "\e[H\e[2J"
        print_board(new_board)
      end
      # print_board(new_board)
      turn += 1
    end
  end

  def result(game_result, user)
    match = Match.create(game_id: 4, user_id: user.id, result: game_result)
    user.save
  end


  def board
    Array.new(10) { Array.new(10, "O") }
  end

  def print_board(board)
    board.each do |r|
      puts r.map { |p| p }.join(" ")
    end
  end

  def ship_row
      rand(10)
  end

  def ship_col
      rand(10)
  end







end
