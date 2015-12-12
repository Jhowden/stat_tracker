class CreateGame < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.date :date_played
      t.integer :winner
      t.belongs_to :home_team, index: true
      t.belongs_to :away_team, index: true
           
      t.timestamps null: false
    end
  end
end
