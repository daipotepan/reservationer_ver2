class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  validates :password,
            presence: true,
            confirmation: true,
            length: { minimum: 6 }

  validates :password_confirmation, presence: true

  has_many :rooms, dependent: :nullify
  has_many :reservations
end
