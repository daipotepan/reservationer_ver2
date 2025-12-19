class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :checkin_date, presence: true
  validates :checkout_date, presence: true
  validates :number_of_people,
            presence: true,
            numericality: { greater_than: 0 }

  validate :checkout_after_checkin

  def stay_days
    return 0 if checkin_date.blank? || checkout_date.blank?
    (checkout_date - checkin_date).to_i
  end

  def total_payment_amount
    return 0 unless room
    room.payment_amount * stay_days * number_of_people
  end

  private

  def checkout_after_checkin
    return if checkin_date.blank? || checkout_date.blank?
    if checkout_date <= checkin_date
      errors.add(:checkout_date, "はチェックイン日より後の日付を選択してください")
    end
  end
end
