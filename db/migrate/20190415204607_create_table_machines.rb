class CreateTableMachines < ActiveRecord::Migration[5.2]
  def change
    create_table :machines do |t|
      t.string :name
      t.integer :game_id
    end
  end
end
