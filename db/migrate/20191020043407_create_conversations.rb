class CreateConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :conversations do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: nil
      t.timestamps
    end
  end
end
