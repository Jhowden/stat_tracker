class CreateAssists < ActiveRecord::Migration
  def change
    create_table :assists do |t|
      t.boolean :ppp
      t.integer :period
      t.string :type
      t.belongs_to :player, index: true
      t.belongs_to :goal, index: true
           
      t.timestamps null: false
    end
  end
end
