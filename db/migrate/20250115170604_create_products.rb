class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :brand
      t.string :color
      t.string :model_label
      t.string :model_number
      t.string :memory

      t.timestamps
    end
  end
end
