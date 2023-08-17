class CreateCompanyInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :company_infos do |t|
      t.string :company_name, null: false
      t.string :postcode,   null: false
      t.string :address, null: false
      t.string :phone_number, null: false
      t.string :fax_number, null: false
      t.timestamps
    end
  end
end
