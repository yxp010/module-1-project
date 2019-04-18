class Game < ActiveRecord::Base
  has_many :reviews
  has_many :matches
  has_many :machines
  has_many :users, through: :matches

  def self.top_ten_most_popular_games
    puts "\e[H\e[2J"
    rank = 1
    rows = []
    game_arr = self.all.sort_by {|game| game.matches.count}.reverse
    game_arr.each do |game|
      arr = [rank, game.name, game.matches.count]
      rows << arr
      rank += 1
    end
    table = Terminal::Table.new :title => "Top 10 Most Popular Games", :headings => ['No.', 'Game', 'Number of Gameplays'], :rows => rows
    # puts table
  end



end
