class AddRegexesToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :regexes, :text
  end
end
