class Room < ApplicationRecord

  validates :name, presence: true
  validates :introduction, presence: true
  validates :payment_amount, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :address, presence: true
end
