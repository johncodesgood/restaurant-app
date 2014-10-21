class CreateFoodsTable < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :name
      t.string :cuisine
      t.integer :price
      t.string :allergens

      t.timestamps
    end
  end
end
