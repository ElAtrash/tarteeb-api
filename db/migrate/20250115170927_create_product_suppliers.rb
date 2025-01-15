class CreateProductSuppliers < ActiveRecord::Migration[8.0]
  def change
    create_table :product_suppliers do |t|
      t.references :product, null: false, foreign_key: true
      t.references :supplier, null: false, foreign_key: true
      t.string :country
      t.decimal :price, precision: 10, scale: 2
      t.integer :quantity
      t.integer :status, default: 0
      t.integer :stock_condition, default: 0
      t.string :estimate
      t.string :location

      t.timestamps
    end
  end
end
