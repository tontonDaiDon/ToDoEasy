class CreateShoppingLists < ActiveRecord::Migration[7.1]
  def change
    create_table :shopping_lists do |t|
      t.string :title
      t.integer :budget
      t.date :shopped_on

      t.timestamps
    end
  end
end
