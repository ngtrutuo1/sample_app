class DropAndCreateMicroposts < ActiveRecord::Migration[7.0]
  def change
    drop_table :microposts, if_exists: true

    create_table :microposts do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :microposts, [:user_id, :created_at]
  end
end
