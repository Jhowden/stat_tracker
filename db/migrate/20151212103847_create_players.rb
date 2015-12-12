class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :real_name
      t.string :player_name
      t.belongs_to :team
           
      t.timestamps null: false
    end
  end
end
