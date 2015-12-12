class CreateSecondaryAssists < ActiveRecord::Migration
  def change
    create_table :secondary_assists do |t|
      t.boolean :ppp
      t.integer :period
      t.belongs_to :players
      t.belongs_to :goals, index: true
           
      t.timestamps null: false
    end
  end
end
