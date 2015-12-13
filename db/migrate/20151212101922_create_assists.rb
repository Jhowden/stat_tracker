class CreateAssists < ActiveRecord::Migration
  def change
    create_table :assists do |t|
      t.boolean :ppp
      t.integer :period
      t.belongs_to :players, index: true
      t.belongs_to :goals, index: true
           
      t.timestamps null: false
    end
  end
end
