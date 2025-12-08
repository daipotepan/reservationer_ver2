class User < ApplicationRecord

  
  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :conf_password, presence: true

  validate :password_not_iq

  def password_not_iq
    return if password.blank? || conf_password.blank?
    if password != conf_password
      errors.add("パスワードが一致しません")
    end
  end

  has_many :rooms, dependent: :nullify
  has_many :reservations
end
