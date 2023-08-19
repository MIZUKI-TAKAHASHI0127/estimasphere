class CreateRepresentatives < ActiveRecord::Migration[6.0]
  def change
    create_table :representatives do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :department_name
      t.string :representative_name
      t.string :phone_number
      t.string :email
      t.timestamps
    end
  end
end
