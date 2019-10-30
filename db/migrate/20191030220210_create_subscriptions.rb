class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.string :user_phone, null: false
      t.string :region, null: false
      t.string :region_cep

      t.timestamps
    end
  end
end
