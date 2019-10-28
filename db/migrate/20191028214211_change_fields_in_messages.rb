class ChangeFieldsInMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :token, :string
    remove_column :messages, :intent
    add_column :messages, :conversation_id, :string
    add_column :messages, :user_phone, :string
    add_column :messages, :user_id, :string
    add_column :messages, :message_id, :string
    add_column :messages, :sync, :boolean, :default => false
  end
end
