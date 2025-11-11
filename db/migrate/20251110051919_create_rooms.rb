class CreateRooms < ActiveRecord::Migration[7.2]
  def change
    create_table :rooms do |t|
      t.string :room_img, default: "https://rails-02-sample.herokuapp.com/assets/room/default-image-4e0ac6b8d01335b5b22fe6586af13644ae51dddb6aeabf35b9174e80f13cd09d.png"
      t.string :name
      t.string :introduction
      t.string :address
      t.integer :Payment_amount

      t.timestamps
    end
  end
end