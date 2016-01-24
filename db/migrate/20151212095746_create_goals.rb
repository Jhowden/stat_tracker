class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.belongs_to :player
      t.boolean :ppp
      t.integer :period
      t.string :time_scored
      t.belongs_to :game, index: true
           
      t.timestamps null: false
    end
  end
end
