class ChangeDefaultConversationStatus < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:conversations, :status, '1')
  end
end
