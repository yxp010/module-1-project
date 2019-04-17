
class Controller

  attr_accessor :current_user, :user_info_hash

  def initialize
    
    @user_info_hash = {}

  end

  #Log in page

  def exit_game
    self.print_main_title
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
        self.check_ranks
      when 'Settings'
        self.settings
      when 'Sign out'
        self.loggin_page
      when 'Exit'
        self.exit_game
    end


  end


  #Choose Games
  def choose_games
    print_main_title
    choice = $prompt.select("Choose a game to paly or Return to Lobby.") do |menu|
      menu.choice 'Dice'
      menu.choice 'Rock Paper Scissor'
      menu.choice 'Slot Machine'
      menu.choice 'Return to Lobby'

    end
    case choice
      when 'Dice'
        start_a_game(Dice, choice)
      when 'Rock Paper Scissor'
        start_a_game(RPS, choice)
      when 'Slot Machine'
        start_a_game(SlotMachine, choice)
      when 'Return to Lobby'
        self.lobby
    end
  end

  def start_a_game(game_class, game_name)

    new_game = game_class.create(user_id: current_user.id, machine_id: Machine.random_machine_id)
    new_game.name = game_name
    new_game.start

    # self.current_user = User.find(current_user.id)

    choice = $prompt.select("Continue or Return to lobby") do |menu|
      menu.choice 'Continue'
      menu.choice 'Return to Lobby'
    end

    choice == 'Continue' ? start_a_game(game_class, game_name) : self.lobby
  end


  # Settings
  def settings
    print_main_title
    choice = $prompt.select("Choose a option.") do |menu|
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


  #1. ask a play's user id
  #2. use the user id to search the player object in database
  #3. puts out the player's user id, winrate, total number of gameplays, points.
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
    player_gameplays_row = ["Total Gameplays", player.gameplays]
    rows << player_user_id_row
    rows << player_points_row
    rows << player_winrate
    rows << player_gameplays_row
    table = Terminal::Table.new :title => "Player's Stats", :rows => rows
    puts table
  end


  def check_ranks
    print_main_title
    choice = $prompt.select("Choose a option.") do |menu|
      menu.choice 'Top 10 most points players'
      menu.choice 'Top 10 players of highest number of games'
      menu.choice 'Top 10 winrate players'
      menu.choice 'Most popular games'
      menu.choice 'Return to Lobby'
    end

    case choice
      when 'Top 10 most points players'
        User.top_ten_most_points_players
        self.return_to_ranks
      when 'Top 10 players of highest number of games'
        User.top_ten_most_game_play_players
        self.return_to_ranks
      when 'Top 10 winrate players'
        User.top_ten_winrate_players
        self.return_to_ranks
      when 'Most popular games'
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
    self.check_ranks
  end



  #Create Account
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
      choice = $prompt.select("Please enter a user name.") do |menu|
        menu.choice 'Try again'
        menu.choice 'Return to lobby'
      end
      choice == 'Try again' ? create_account : loggin_page
    else
      password = $prompt.mask('New password:', required: true)
      self.current_user = User.create(user_name: new_user_name, password: password, points: 5000)
      lobby
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
