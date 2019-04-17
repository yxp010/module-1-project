class Game < ActiveRecord::Base
  belongs_to :user
  belongs_to :machine

  def self.top_ten_most_popular_games
    puts "\e[H\e[2J"
    rank = 1
    rows = []
    game_arr = self.all.group(:name).count.sort_by {|key, value| value}.reverse
    game_arr.each do |arr|
      arr.unshift(rank)
      rows << arr
      rank += 1
    end
    table = Terminal::Table.new :title => "Top 10 Most Popular Games", :headings => ['No.', 'Game', 'Number of Gameplays'], :rows => rows
    # puts table
  end
end
