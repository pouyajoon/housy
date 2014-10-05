class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.text :address
      t.string :owner
      t.string :occupants
      t.float :rent
      t.float :apartment_costs
      t.string :send_from_email
      t.string :owners_email
      t.string :occupants_email

      t.timestamps
    end
  end
end
