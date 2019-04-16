class Dice < Game

  attr_accessor :user_number, :cpu_number

  def start
    @cpu_number = throw_dice
    puts "CPU(#{self.machine.name}) throwed #{@cpu_number}"
    @user_number = throw_dice
    puts "You throwed #{user_number}"

    if @cpu_number > @user_number
      self.lost
    elsif @cpu_number < @user_number
      self.win
    else
      self.draw
    end

  end

  def win
    self.user.points += 100
    puts 'You won 100 points'
    self.result('W')
  end

  def lost
    self.user.points -= 100
    puts 'You lost 100 points.'
    self.result('L')
  end

  def draw
    puts 'It is draw, no points!'

    self.result('D')
  end

  def result(result)
    self.result = result
    self.save
    self.user.save
  end

  def throw_dice
    [1, 2, 3, 4, 5, 6].sample
  end
end
