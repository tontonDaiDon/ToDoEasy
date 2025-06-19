class CreatePurchaseHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :purchase_histories do |t|
      t.references :shopping_list, null: false, foreign_key: true
      t.date :purchased_on
      t.integer :total_price

      t.timestamps
    end
  end
end
