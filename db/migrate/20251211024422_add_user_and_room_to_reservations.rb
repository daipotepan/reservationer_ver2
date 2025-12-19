class AddUserAndRoomToReservations < ActiveRecord::Migration[7.2]
  def change
    add_reference :reservations, :user, null: false, foreign_key: true
    add_reference :reservations, :room, null: false, foreign_key: true
  end
end
