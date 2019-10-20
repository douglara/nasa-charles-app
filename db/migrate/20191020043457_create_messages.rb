class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.text :text
      t.boolean :from_me
      t.string :intent
      
      t.timestamps
    end
  end
end
