class CreateTableUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :password
      t.integer :points
    end
  end
end
