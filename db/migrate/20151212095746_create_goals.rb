class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.belongs_to :players
      t.boolean :ppp
      t.integer :period
      t.string :time_scored
      t.belongs_to :games, index: true
           
      t.timestamps null: false
    end
  end
end
