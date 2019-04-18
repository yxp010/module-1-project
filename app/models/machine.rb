class Machine < ActiveRecord::Base

  belongs_to :game

  def self.random_machine_id
    self.all.map {|machine| machine.id}.sample
  end

end
