class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.string :projects
      t.string :owners
      t.boolean :emoji_enabled, :default => true
      t.text :qa_product_approved_emojis
      t.text :qa_approved_emojis
      t.text :product_approved_emojis
      t.text :merged_emojis

      t.timestamps
    end
  end
end
