class User < ActiveRecord::Base

  has_many :games
  has_many :machines, through: :games

  def self.top_ten_most_game_play_players
    puts "\e[H\e[2J"
    rank = 1
    rows = []
    ordered_arr = self.all.sort_by {|user| user.games.count}.reverse[0, 10]
    ordered_arr.each do |user|
      # puts "#{rank}. #{user.user_name}, Games Played: #{user.games.count}"
      rows << [rank, user.user_name, user.games.count]
      rank += 1
    end
    table = Terminal::Table.new :title => "Top 10 Most Experienced Players", :headings => ['No.', 'User ID', 'Gameplays'], :rows => rows
    # puts table
  end

  def self.top_ten_most_points_players
    puts "\e[H\e[2J"

    rank = 1
    rows = []
    self.order(points: :desc).limit(10).each do |user|
      rows << [rank, user.user_name, user.points]
      rank += 1
    end
    table = Terminal::Table.new :title => "Top 10 Most Points Players", :headings => ['No.', 'User ID', 'Points'], :rows => rows
    # puts table
  end

  def self.top_ten_winrate_players
    puts "\e[H\e[2J"
    rows = []
    top_winrate_players = User.all.sort_by do |user|
      user.winrate
    end.reverse[0, 10]

    top_winrate_players.each do |player|
      # puts "#{player.user_name}, Winrate: #{player.winrate}%"
      rows << [player.user_name, "#{player.winrate}%"]
    end
    table = Terminal::Table.new :title => "Top 10 Winrate Players", :headings => ['User ID', 'Winrate'], :rows => rows
    # puts table

  end



  def winrate
    if self.games.count == 0
      0
    else
      ((self.games.select {|game| game.result == 'W'}.count / self.games.count.to_f) * 100).floor(2)
    end

  end

  def gameplays
    if self.games == nil
      0
    else
      self.games.count
    end
  end

  def change_password(new_password)
    if new_password == nil
      choice = $prompt.select("Please enter a password at least 1 character") do |menu|
        menu.choice 'Try again'
        menu.choice 'Return to Settings'
      end
      choice == 'Try again' ? self.search_a_player : self.settings
    else
      self.password = new_password
      self.save
    end

  end

  def delete_account
    User.delete(self.id)
  end


end
