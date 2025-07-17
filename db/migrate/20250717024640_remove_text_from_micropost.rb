class RemoveTextFromMicropost < ActiveRecord::Migration[7.0]
  def change
    remove_column :microposts, :text, :string
  end
end
