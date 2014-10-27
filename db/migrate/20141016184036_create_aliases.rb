class CreateAliases < ActiveRecord::Migration
  def change
    create_table :aliases do |t|
      t.string :gerrit_username
      t.string :slack_username

      t.timestamps
    end
  end
end
