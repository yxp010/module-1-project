

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
    end
    choice == 'Choose games' ? choose_games : settings
  end

  def choose_games
    puts "choose_games"
  end

  def settings
    puts "settings"
  end


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
    current_user = User.find_by(user_info_hash)
    lobby
  end
end
