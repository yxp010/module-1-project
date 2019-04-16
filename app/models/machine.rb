class Machine < ActiveRecord::Base

  has_many :games
  has_many :users, through: :games

  def self.random_machine_id
    self.all.map {|machine| machine.id}.sample
  end

end
