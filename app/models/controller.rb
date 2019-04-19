


class Controller

  attr_accessor :current_user, :user_info_hash

  def initialize

    @user_info_hash = {}

  end

  #Log in page

  def exit_game
    font = TTY::Font.new("standard")
    byebye = font.write("BYE BYE")
    puts "\e[H\e[2J"
    puts Paint[byebye, '#FFD700']
    exit
  end

  def main_title_color
    "00BFFF"
  end

  def print_main_title
    puts "\e[H\e[2J"
    puts Paint[main_title_box, main_title_color]
  end

  def main_title
    font = TTY::Font.new("3d")
    font.write("VAPOR")
  end

  def main_title_box
    TTY::Box.frame(width: 70, height: 10, border: :thick, align: :center, title: {top_left: 'VAPOR', bottom_right: 'v1.0'}) do
      main_title
    end
  end

  def loggin_page
    print_main_title

    choice = $prompt.select("Sign in or Create an account.") do |menu|
      menu.choice 'Sign In'
      menu.choice 'Create Account'
      menu.choice 'Exit'
    end

    case choice
      when 'Sign In'
        self.sign_in
      when 'Create Account'
        self.create_account
      when 'Exit'
        self.exit_game
    end
  end

  #Lobby
  def lobby
    print_main_title
    choice = $prompt.select("Lobby") do |menu|
      menu.choice 'Choose games'
      menu.choice 'Check Leaderboards'
      menu.choice 'Game Reviews'
      menu.choice 'Settings'
      menu.choice 'Sign out'
      menu.choice 'Exit'
    end
    # binding.pry
    # choice == 'Choose games' ? choose_games : settings
    case choice
      when 'Choose games'
        self.choose_games
      when 'Check Leaderboards'
        self.leaderboards
      when 'Game Reviews'
        self.game_reviews
      when 'Settings'
        self.settings
      when 'Sign out'
        self.loggin_page
      when 'Exit'
        self.exit_game
    end


  end

  def game_reviews
    print_main_title
    choice = $prompt.select("Games") do |menu|
      menu.choice 'Dice'
      menu.choice 'Rock Paper Scissors'
      menu.choice 'Slot Machine'
      menu.choice 'Battleship'
      menu.choice 'Return to Lobby'
    end

    case choice
      when 'Dice'
        puts "\e[H\e[2J"
        puts Paint[review_table(1), '#FFD700']
        review = self.write_review_or_return
        self.current_user.write_review(review, 1)
        self.return_to_game_reviews(1)
      when 'Rock Paper Scissors'
        puts "\e[H\e[2J"
        puts Paint[review_table(2), '#FFD700']
        review = self.write_review_or_return
        self.current_user.write_review(review, 2)
        self.return_to_game_reviews(2)
      when 'Slot Machine'
        puts "\e[H\e[2J"
        puts Paint[review_table(3), '#FFD700']
        review = self.write_review_or_return
        self.current_user.write_review(review, 3)
        self.return_to_game_reviews(3)
      when 'Battleship'
        puts "\e[H\e[2J"
        puts Paint[review_table(4), '#FFD700']
        review = self.write_review_or_return
        self.current_user.write_review(review, 4)
        self.return_to_game_reviews(4)
      when 'Return to Lobby'
        self.lobby
    end
  end

  def return_to_game_reviews(game_id)
    puts "\e[H\e[2J"
    puts Paint[review_table(game_id), '#FFD700']
    ask_to_return('Game Reviews')
    self.game_reviews
  end

  def review_table(game_id)
    game = Game.find(game_id)
    rows = []
    latest_ten_reviews = game.reviews.reverse[0, 10]
    latest_ten_reviews.each do |review|
      arr = [review.user.user_name, review.created_at, review.content]
      rows << arr
    end

    table = Terminal::Table.new :title => "Lastest Reviews(#{game.name})", :headings => ['User ID', 'Date', 'Review'], :rows => rows
  end

  def write_review_or_return
    choice = $prompt.select("===============") do |menu|
      menu.choice 'Write a review'
      menu.choice 'Return to previous menu'
    end

    case choice
      when 'Write a review'
        review = $prompt.ask('Enter Review: ')
        choice = $prompt.select("Check your review: '#{review}'") do |menu|
          menu.choice "Submit(Automatically discard if it's empty)"
          menu.choice 'Discard'
        end
        case choice
        when "Submit(Automatically discard if it's empty)"
            if review == nil
              self.game_reviews
            else
              review
            end
          when 'Discard'
            self.game_reviews
        end

      when 'Return to previous menu'
        self.game_reviews
    end
  end

  #Choose Games
  def choose_games
    print_main_title
    choice = $prompt.select("Game Menu") do |menu|
      menu.choice 'Dice'
      menu.choice 'Rock Paper Scissors'
      menu.choice 'Slot Machine'
      menu.choice 'Battleship'
      menu.choice 'Return to Lobby'

    end
    case choice
      when 'Dice'
        start_a_game(choice)
      when 'Rock Paper Scissors'
        start_a_game(choice)
      when 'Slot Machine'
        start_a_game(choice)
      when 'Battleship'
        start_a_game(choice)
      when 'Return to Lobby'
        self.lobby
    end
  end

  def start_a_game(game_choice)
    new_game = nil
    case game_choice
      when 'Dice'
        new_game = Dice.find_by(name: game_choice)
      when 'Rock Paper Scissors'
        new_game = RPS.find_by(name: game_choice)
      when 'Slot Machine'
        new_game = SlotMachine.find_by(name: game_choice)
      when 'Battleship'
        new_game = BattleShip.find_by(name: game_choice)
    end

    new_game.start(current_user)

    choice = $prompt.select("Continue or Return to lobby") do |menu|
      menu.choice 'Continue'
      menu.choice 'Return to choose different games'
    end

    choice == 'Continue' ? start_a_game(game_choice) : self.choose_games
  end


  # Settings
  def settings
    print_main_title
    choice = $prompt.select("Settings") do |menu|
      menu.choice 'Check Account Information'
      menu.choice 'Change Password'
      menu.choice 'Search a player'
      menu.choice 'Delete Account'
      menu.choice 'Return to Lobby'

    end

    case choice
      when 'Check Account Information'
        self.check_account_info
      when 'Change Password'


        self.change_password

      when 'Search a player'
        self.search_a_player
      when 'Delete Account'
        current_user.delete_account
        self.loggin_page
      when 'Return to Lobby'
        self.lobby
    end
  end

  def change_password
    print_main_title
    new_password = $prompt.mask("Please enter a new password:")
    if new_password == nil
      choice = $prompt.select("Please enter a password at least 1 character") do |menu|
        menu.choice 'Try again'
        menu.choice 'Return to Settings'
      end
      choice == 'Try again' ? self.change_password : self.settings
    else
      current_user.change_password(new_password)
      puts 'Changed password successfully!!'
      self.return_to_settings
    end
  end

  def search_a_player
    self.print_main_title
    user_name = $prompt.ask("Please enter the player's user id:")
    if user_name == nil
      choice = $prompt.select("Please enter a user id. Try again or return to Settings.") do |menu|
        menu.choice 'Try again'
        menu.choice 'Return to Settings'
      end
      choice == 'Try again' ? self.search_a_player : self.settings
    else
      player_object = User.find_by(user_name: user_name)

      if player_object == nil
        choice = $prompt.select("Please enter a correct User ID.") do |menu|
          menu.choice 'Try again'
          menu.choice 'Return to Settings'
        end
        choice == 'Try again' ? self.search_a_player : self.settings
      end

      self.print_out_player_stats(player_object)
      self.return_to_settings

    end


  end

  def print_out_player_stats(player)
    puts "\e[H\e[2J"
    rows = []
    player_user_id_row = ["Uer ID", player.user_name]
    player_points_row = ["Points", player.points]
    player_winrate = ["Winrate", "#{player.winrate}%"]
    player_gameplays_row = ["Total Gameplays", player.matches.count]
    rows << player_user_id_row
    rows << player_points_row
    rows << player_winrate
    rows << player_gameplays_row
    table = Terminal::Table.new :title => "Player's Stats", :rows => rows
    puts Paint[table, 'FFD700']
  end


  def leaderboards
    print_main_title
    choice = $prompt.select("Leaderboards") do |menu|
      menu.choice 'Top 10 most points players'
      menu.choice 'Top 10 players of highest number of games'
      menu.choice 'Top 10 winrate players'
      menu.choice 'Top 10 Popular Games'
      menu.choice 'Return to Lobby'
    end

    case choice
      when 'Top 10 most points players'
        puts Paint[User.top_ten_most_points_players, '#FFD700']
        self.return_to_ranks
      when 'Top 10 players of highest number of games'
        puts Paint[User.top_ten_most_game_play_players, '#FFD700']
        self.return_to_ranks
      when 'Top 10 winrate players'
        puts Paint[User.top_ten_winrate_players, '#FFD700']
        self.return_to_ranks
      when 'Top 10 Popular Games'
        puts Paint[Game.top_ten_most_popular_games, '#FFD700']
        self.return_to_ranks
      when 'Return to Lobby'
        self.lobby
    end
  end

  def check_account_info
    print_main_title
    choice = $prompt.select("Choose a option.") do |menu|
      menu.choice 'User name'
      menu.choice 'Password'
      menu.choice 'Points'
      menu.choice 'Return to settings'
    end

    case choice
      when 'User name'
        self.print_main_title
        puts "Your user name: #{self.current_user.user_name}."
        self.return_to_check_account_info
      when 'Password'
        self.print_main_title
        puts "Your password: #{self.current_user.password}."
        self.return_to_check_account_info
      when 'Points'
        self.print_main_title
        puts "Your points: #{self.current_user.points}."
        self.return_to_check_account_info
      when 'Return to settings'
        self.settings
    end

  end

  #ASK USER TO PRESS ENTER OR SPACE TO RETURN SPECIFIC PAGE
  def ask_to_return(menu)
    $prompt.keypress("Press space or enter to return to #{menu}.", keys: [:space, :return])
  end

  def return_to_check_account_info
    self.ask_to_return('Check Account Information')
    self.check_account_info
  end

  def return_to_settings
    self.ask_to_return('Settings')
    self.settings
  end

  def return_to_ranks
    self.ask_to_return('Check Ranks')
    self.leaderboards
  end



  #Create Account // NEED TO FIX INTER PASSWORD
  def create_account
    print_main_title
    new_user_name = $prompt.ask('New user name:')
    if User.find_by(user_name: new_user_name)
      choice = $prompt.select("User name already exists. Please choose a different one.") do |menu|
        menu.choice 'Try again'
        menu.choice 'Return to lobby'
      end
      choice == 'Try again' ? create_account : loggin_page
    elsif new_user_name == nil
      choice = $prompt.select("Please enter a user name:") do |menu|
        menu.choice 'Try again'
        menu.choice 'Return to lobby'
      end
      choice == 'Try again' ? create_account : loggin_page
    else
      password = $prompt.mask('New password:')
      if password == nil
        choice = $prompt.select("Please enter a password:") do |menu|
          menu.choice 'Try again'
          menu.choice 'Return to lobby'
        end
        choice == 'Try again' ? create_account : loggin_page
      else
        self.current_user = User.create(user_name: new_user_name, password: password, points: 5000)
        lobby
      end
    end
  end

  # Sign In
  def insert_user_name
    print_main_title
    user_name = $prompt.ask('What is your user name?')
    if User.find_by(user_name: user_name)
      user_info_hash[:user_name] = user_name
    else
      choice = $prompt.select("The user name does not exist. Please try again or return to lobby.") do |menu|
        menu.choice 'Try again'
        menu.choice 'Return to lobby'
      end
      choice == 'Try again' ? insert_user_name : loggin_page
    end
  end

  def insert_password
    print_main_title
    password = $prompt.mask('What is your password?')

    if password == User.find_by(user_info_hash).password
      puts "loggin successfully"
    else
      choice = $prompt.select("The password is not correct. Please try again or return to lobby.") do |menu|
        menu.choice 'Try again'
        menu.choice 'Return to lobby'
      end
      choice == 'Try again' ? insert_password : loggin_page
    end

    # insert_user_name.password == password ? puts "going to lobby" : $prompt.select("Try again or Return to lobby.", %w(try_again(insert_user_name) return))
  end

  def sign_in

    insert_user_name
    insert_password
    # User.find_by(user_name: ,password: )
    self.current_user = User.find_by(user_info_hash)
    lobby
  end
end
