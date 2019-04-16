

class Controller

  attr_accessor :current_user, :user_info_hash

  def initialize
    @current_user = current_user
    @user_info_hash = {}
  end

  def loggin_page
    puts "Welcome to Vapor!!"
    puts "================="

    choice = $prompt.select("Sign in or Create an account.") do |menu|
      menu.choice 'Sign In'
      menu.choice 'Create Account'
    end
    choice == 'Sign In' ? sign_in : create_account
  end

  def lobby
    choice = $prompt.select("Lobby") do |menu|
      menu.choice 'Choose games'
      menu.choice 'Settings'
      menu.choice 'Sign out'
      menu.choice 'Exit'
    end
    # binding.pry
    # choice == 'Choose games' ? choose_games : settings
    case choice
      when 'Choose games'
        self.choose_games
      when 'Settings'
        self.settings
      when 'Sign out'
        self.loggin_page
      when 'Exit'
        exit
    end


  end



  #Choose Games
  def choose_games
    choice = $prompt.select("Choose a game to paly or Return to Lobby.") do |menu|
      menu.choice 'Dice'
      menu.choice 'Return to Lobby'
    end
    # choice == 'Dice' ? sign_in : create_account
    case choice
      when 'Dice'
        start_a_game(Dice, choice)
      when 'Return to Lobby'
        self.lobby
    end
  end

  def start_a_game(game_class, game_name)
    new_game = game_class.create(user_id: current_user.id, machine_id: Machine.random_machine_id)
    new_game.name = game_name
    new_game.save
    new_game.start

    choice = $prompt.select("Continue or Return to lobby") do |menu|
      menu.choice 'Continue'
      menu.choice 'Return to Lobby'
    end

    choice == 'Continue' ? start_a_game(game_class, game_name) : self.lobby
  end



  # Settings
  def settings
    choice = $prompt.select("Choose a option.") do |menu|
      menu.choice 'Check Account Information'
      menu.choice 'Return to Lobby'
    end

    case choice
      when 'Check Account Information'
        self.check_account_info
      when 'Return to Lobby'
        self.lobby
    end
  end

  def check_account_info
    choice = $prompt.select("Choose a option.") do |menu|
      menu.choice 'User name'
      menu.choice 'Password'
      menu.choice 'Points'
      menu.choice 'Return to settings'
    end

    case choice
      when 'User name'
        puts "Your user name: #{self.current_user.user_name}."
        self.return_to_check_account_info
      when 'Password'
        puts "Your password: #{self.current_user.password}."
        self.return_to_check_account_info
      when 'Points'
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
    self.ask_to_return('check account information')
    self.check_account_info
  end



  #Create Account
  def create_account
    new_user_name = $prompt.ask('New user name:', default: ENV['USER'])
    if User.find_by(user_name: new_user_name)
      choice = $prompt.select("User name already exists. Please choose a different one.") do |menu|
        menu.choice 'Try again'
        menu.choice 'Return to lobby'
      end
      choice == 'Try again' ? create_account : loggin_page
    else
      password = $prompt.mask('New password:', default: ENV['USER'])
      current_user = User.create(user_name: new_user_name, password: password)
      lobby
    end
  end

  # Sign In
  def insert_user_name
    user_name = $prompt.ask('What is your user name?', default: ENV['USER'])
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
    password = $prompt.mask('What is your password?')
    # binding.pry
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
