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

end
