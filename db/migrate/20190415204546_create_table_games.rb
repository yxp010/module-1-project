class CreateTableGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :name
    end
  end
end
