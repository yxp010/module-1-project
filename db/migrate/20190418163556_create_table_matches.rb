class CreateTableMatches < ActiveRecord::Migration[5.2]
  def change

    create_table :matches do |t|
      t.integer :user_id
      t.integer :game_id
      t.string :result
    end
  end
end
