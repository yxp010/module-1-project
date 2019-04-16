class CreateTableGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :user_id
      t.integer :machine_id
    end
  end
end
