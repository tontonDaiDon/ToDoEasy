class AddNameToShoppingLists < ActiveRecord::Migration[7.1]
  def change
    add_column :shopping_lists, :name, :string
  end
end
