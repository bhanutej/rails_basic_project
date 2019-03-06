class CreateUserOtps < ActiveRecord::Migration[5.0]
  def change
    create_table :user_otps do |t|
      t.references :user, foreign_key: true
      t.string :otp_value
      t.boolean :is_validated
      t.datetime :expiry_date

      t.timestamps
    end
  end
end
