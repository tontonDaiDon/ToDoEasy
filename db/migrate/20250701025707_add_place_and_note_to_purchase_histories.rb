class AddPlaceAndNoteToPurchaseHistories < ActiveRecord::Migration[7.1]
  def change
    add_column :purchase_histories, :place, :string
    add_column :purchase_histories, :note, :text
  end
end
