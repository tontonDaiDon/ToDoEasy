class AddShoppedOnToShoppingLists < ActiveRecord::Migration[7.1]
  def change
    add_column :shopping_lists, :shopped_on, :date
  end
end
