class User < ApplicationRecord
  # Devise関連
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [:login]

  attr_accessor :login

  has_many :shopping_lists, dependent: :destroy
  has_many :purchase_histories, through: :shopping_lists

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions).where(
        ["lower(nickname) = :value OR lower(email) = :value", { value: login.downcase }]
      ).first
    else
      where(conditions).first
    end
  end
end
