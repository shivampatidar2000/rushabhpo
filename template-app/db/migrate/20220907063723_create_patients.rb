class CreatePatients < ActiveRecord::Migration[6.0]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.bigint :phone_no
      t.bigint :alternative_no
      t.string :address
      t.integer :account_id
      t.string :gender
      t.string :date_of_birth
      t.integer :weight
      t.string :diabetes
      t.string :city
      t.string :landmark
      t.integer :pincode
      t.string :country
      t.string :reference
    end
  end
end
