class User < ActiveRecord::Base

  has_many :games
  has_many :machines, through: :games

  # def initialize
  #   @points = 5000
  # end

end
