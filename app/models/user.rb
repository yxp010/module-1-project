class User < ActiveRecord::Base

  has_many :reviews
  has_many :matches
  has_many :games, through: :reviews

  def self.top_ten_most_game_play_players
    puts "\e[H\e[2J"
    rank = 1
    rows = []
    top_ten_array = self.all.sort_by {|user| user.matches.count}.reverse[0, 10]
    # ordered_arr = self.all.sort_by {|user| user.games.count}.reverse[0, 10]
    top_ten_array.each do |user|
      # puts "#{rank}. #{user.user_name}, Games Played: #{user.games.count}"
      rows << [rank, user.user_name, user.matches.count]
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
    if self.matches.count == 0
      0
    else
      ((self.matches.select {|match| match.result == 'W'}.count / self.matches.count.to_f) * 100).floor(2)
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

    self.password = new_password
    self.save
  end

  def delete_account
    Review.where(user_id: self.id).delete_all
    Match.where(user_id: self.id).delete_all
    User.delete(self.id)
  end

  def write_review(content, game_id)
    Review.create(content: content, user_id: self.id, game_id: game_id)
  end


end
