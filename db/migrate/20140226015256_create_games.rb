class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.text :name
      t.text :category
      t.text :description
      t.integer :plays_quantity
      t.text :comments, array: true, default: []
      t.integer :rating, array: true, default: []

      t.timestamps
    end
  end
end
