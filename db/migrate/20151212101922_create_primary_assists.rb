class CreatePrimaryAssists < ActiveRecord::Migration
  def change
    create_table :primary_assists do |t|
      t.boolean :ppp
      t.integer :period
      t.belongs_to :players
      t.belongs_to :goals, index: true
           
      t.timestamps null: false
    end
  end
end
