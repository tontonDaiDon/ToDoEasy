class PurchaseHistory < ApplicationRecord
  belongs_to :shopping_list
  has_one_attached :receipt_image

  validates :purchased_on, presence: true
  validates :place, presence: true
end
