class ShoppingList < ApplicationRecord
    has_many :items, dependent: :destroy
end

