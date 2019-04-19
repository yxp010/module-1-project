class Dice < Game

  attr_accessor :user_number, :cpu_number

  def start(user)

    @cpu_number = throw_dice
    puts "CPU(#{self.machines.sample.name}) throwed #{@cpu_number}"
    @user_number = throw_dice
    puts "You throwed #{user_number}"

    if @cpu_number > @user_number
      user.points -= 100
      puts Paint['You lost 100 points.', :red, :bright]
      result('L', user)
    elsif @cpu_number < @user_number
      user.points += 100
      puts Paint['You won 100 points', :red, :bright]
      result('W', user)
    else
      puts Paint['It is draw, no points!', :red, :bright]
      result('D', user)
    end

  end

  def result(game_result, user)
    match = Match.create(game_id: 1, user_id: user.id, result: game_result)
    user.save
  end

  def throw_dice
    [1, 2, 3, 4, 5, 6].sample
  end
end
