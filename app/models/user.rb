class User < ActiveRecord::Base

  has_many :games
  has_many :machines, through: :games

  # def initialize
  #   @points = 5000
  # end

  def self.top_ten_most_game_play_players
    rank = 1
    ordered_arr = self.all.sort_by {|user| user.games.count}.reverse[0, 10]
    ordered_arr.each do |user|
      puts "#{rank}. #{user.user_name}, Games Played: #{user.games.count}"
      rank += 1
    end
  end

  def self.top_ten_most_points_players
    rank = 1
    self.order(points: :desc).limit(10).each do |user|
      puts "#{rank}. #{user.user_name}, Points: #{user.points}"
      rank += 1
    end
  end

  def self.top_ten_winrate_players

    top_winrate_players = User.all.sort_by do |user|
      user.winrate
    end.reverse[0, 10]

    top_winrate_players.each do |player|
      puts "#{player.user_name}, Winrate: #{player.winrate}%"
    end

  end



  def winrate
    if self.games.count == 0
      0
    else
      (self.games.select {|game| game.result == 'W'}.count / self.games.count.to_f) * 100
    end

  end



    # self.all.sort_by {|user| user.games.select {|game| game.result == 'W'}.count / user.games.count}[-10, 10]
    # Game.all.group(:user_id)
    # all_user_winrates = User.all.map do |user|
    #   winned_games = user.games.select {|game| game.result == 'W'}
    #   winned_games.count / user.games.count
    # end
  # end

end
