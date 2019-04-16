class RPS < Game

attr_accessor :user_hand , :cpu_hand

  def start
    @user_hand = $prompt.select("Choose an option:") do |menu|
      menu.choice 'Rock'
      menu.choice 'Paper'
      menu.choice 'Scissors'
    end
    puts "You put #{@user_hand}"
    @cpu_hand = self.hand #this has to be input from user HOW???
    puts "CPU puts #{@cpu_hand} "
#THIS IS  NOT FINAL FORM ... JUST PROCESS... not sure what is the syntax for multiple conditions
    if @user_hand == "Rock" && @cpu_hand == "Rock"
      self.tie
    elsif @user_hand == "Rock" && @cpu_hand == "Scissors"
      self.win
    elsif @user_hand == "Rock" && @cpu_hand == "Paper"
      self.lost
    elsif @user_hand == "Paper" && @cpu_hand == "Rock"
      self.win
    elsif @user_hand == "Paper" && @cpu_hand == "Scissors"
      self.lost
    elsif @user_hand == "Paper" && @cpu_hand == "Paper"
      self.tie
    elsif @user_hand == "Scissors" && @cpu_hand == "Rock"
      self.lost
    elsif @user_hand == "Scissors" && @cpu_hand == "Scissors"
      self.tie
    elsif @user_hand == "Scissors" && @cpu_hand == "Paper"
      self.win
    end
  end

  def win
    self.user.points += 100
    result('W')
    puts 'You won 100 points.'
  end
  def lost
    self.user.points -= 100
    result('L')
    puts 'You lost 100 points.'
  end
  def tie
    result('D')
    puts 'Draw.'
  end

  def result(result)
    self.result = result
    self.save
    self.user.save
  end

  def hand
    ["Rock","Paper","Scissors"].sample
  end
end
