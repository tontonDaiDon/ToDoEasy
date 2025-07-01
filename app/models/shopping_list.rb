class ShoppingList < ApplicationRecord
    has_many :items, dependent: :destroy
    has_many :purchase_histories
end

