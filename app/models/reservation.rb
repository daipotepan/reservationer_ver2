class Reservation < ApplicationRecord

  validates :checkin_date, presence: true
  validates :checkout_date, presence: true
  validates :number_of_people, presence: true

  validate :checkout_date_after_checkin_date
  validate :today_date_after_checkin_date

  def checkout_date_after_checkin_date
    return if checkin_date.blank? || checkout_date.blank?
    if checkout_date < checkin_date
      errors.add(:checkout_date, "はチェックイン日より後にしてください")
    end
  end

  def today_date_after_checkin_date
    return if checkin_date.blank?

    if Date.today < checkin_date
      errors.add(:checkin_date, "は本日よりも後にしてください")
end
