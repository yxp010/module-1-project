class RPS < Game

attr_accessor :user_hand , :cpu_hand

  def start(user)
    @user_hand = $prompt.select("Choose an option:") do |menu|
      menu.choice 'Rock'
      menu.choice 'Paper'
      menu.choice 'Scissors'
    end
    puts "You put #{@user_hand}"
    @cpu_hand = self.hand #this has to be input from user HOW???
    puts "CPU(#{self.machines.sample.name}) puts #{@cpu_hand} "
#THIS IS  NOT FINAL FORM ... JUST PROCESS... not sure what is the syntax for multiple conditions
    if @user_hand == "Rock" && @cpu_hand == "Rock"
      self.result('D', user)
    elsif @user_hand == "Rock" && @cpu_hand == "Scissors"
      self.result('W', user)
    elsif @user_hand == "Rock" && @cpu_hand == "Paper"
      self.result('L', user)
    elsif @user_hand == "Paper" && @cpu_hand == "Rock"
      self.result('W', user)
    elsif @user_hand == "Paper" && @cpu_hand == "Scissors"
      self.result('L', user)
    elsif @user_hand == "Paper" && @cpu_hand == "Paper"
      self.result('D', user)
    elsif @user_hand == "Scissors" && @cpu_hand == "Rock"
      self.result('L', user)
    elsif @user_hand == "Scissors" && @cpu_hand == "Scissors"
      self.result('D', user)
    elsif @user_hand == "Scissors" && @cpu_hand == "Paper"
      self.result('W', user)
    end
  end

  def result(game_result, user)
    case game_result
      when 'W'
        user.points += 100
        puts 'Congratulations!! You won 100 points!!'
      when 'D'
        puts 'Draw, no points.'
      when 'L'
        user.points -= 100
        puts 'Sorry, you lost 100 points.'
    end
    match = Match.create(game_id: 2, user_id: user.id, result: game_result)
    user.save
  end

  def hand
    ["Rock","Paper","Scissors"].sample
  end
end
