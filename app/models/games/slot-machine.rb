class SlotMachine < Game


  # TO DO: Let users know the rules.







  attr_accessor :symbols, :slots, :colors

  def setup_machine
    font = TTY::Font.new(:standard)
    @symbols = [font.write("@"), font.write("$"), font.write("%"), font.write("&"), font.write("*")]
    @slots = [nil, nil, nil]
    @colors = ['#00FFFF', '#7FFFD4', '#0000FF', '#8A2BE2', '#FF7F50', '#6495ED', '#DC143C', '#006400', '#8B008B', '#9932CC', '#8B0000', '#483D8B', '#FF1493', '#1E90FF', '#B22222', '#FFD700', '#008000', '#C71585', '#FF4500', '#FF0000', '#800080']
  end

  def start
    setup_machine
    puts "\e[H\e[2J"
    puts Paint[self.starting_table, '#FFD700']
    $prompt.keypress("Press space or enter to pull lever.", keys: [:space, :return])
    pull_lever
  end

  def starting_table
    rows = []
    self.slots = [self.symbols[1], self.symbols[1], self.symbols[1]]
    rows << self.slots
    table = Terminal::Table.new :rows => rows
  end

  def pull_lever
    rows = []
    slots.each_with_index do |symbol, index|
      self.slots[index] = self.symbols.sample
      rows << self.slots
      table = Terminal::Table.new :rows => rows

      puts "\e[H\e[2J"
      puts Paint[table, self.colors.sample]
      rows = []
      sleep(1)
    end
    self.check_result
  end

  def check_result
    if slots[0] == slots[1] && slots[1] == slots[2]
      self.user.points += 1000
      self.result("W")
      puts "Congratulations!! You won 1000 points!!"
    elsif slots[0] == slots[1] || slots[1] == slots[2] || slots[0] == slots[2]
      self.user.points += 100
      self.result("W")
      puts "Congratulations!! You won 100 points!!"
    else
      self.user.points -= 50
      self.result("L")
      puts "Sorry, You lost 50 points :("
    end
  end

  def result(result)
    self.result = result
    self.save
    self.user.save
  end


end
