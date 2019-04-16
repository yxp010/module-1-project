class Game < ActiveRecord::Base
  belongs_to :user
  belongs_to :machine

end

class Dice < Game

  attr_accessor :user_number, :cpu_number

  # def initialize
  #   self.name = "Dice"
  # end

  def start
    @cpu_number = throw_dice
    puts "CPU(#{self.machine.name}) throwed #{@cpu_number}"
    @user_number = throw_dice
    puts "You throwed #{user_number}"

    @cpu_number > @user_number ? self.lost : self.win
  end

  def win
    self.user.points += 100
    self.user.save
    puts 'You won 100 points'
  end

  def lost
    self.user.points -= 100
    self.user.save
    puts 'You lost 100 points.'
  end

  def throw_dice
    [1, 2, 3, 4, 5, 6].sample
  end
end
