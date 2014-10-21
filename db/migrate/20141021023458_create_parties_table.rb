class CreatePartiesTable < ActiveRecord::Migration
  def change
      create_table :parties do |t|
      t.string :name
      t.integer :table_num
      t.integer :num_guests
      t.boolean :paid

      t.timestamps
    end
  end
end
