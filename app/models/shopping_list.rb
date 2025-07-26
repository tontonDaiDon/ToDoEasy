class ShoppingList < ApplicationRecord
    has_many :items, dependent: :destroy
  has_many :purchase_histories, dependent: :destroy

  def total_price
    items.sum(:price) # 各itemにpriceカラムがある場合
  end

  def purchased_total_price
    items.select(&:purchased).sum { |item| (item.price || 0) * (item.quantity || 1) }
  end
end

