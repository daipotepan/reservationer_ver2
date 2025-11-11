class CreateReservations < ActiveRecord::Migration[7.2]
  def change
    create_table :reservations do |t|
      t.date :checkin_date
      t.date :checkout_date
      t.integer :number_of_people

      t.timestamps
    end
  end
end
