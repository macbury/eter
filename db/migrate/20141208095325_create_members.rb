class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.integer :user_id, null: false
      t.integer :source_id, null: false
      t.string :source_type, null: false
      t.string :role, null: false

      t.timestamps
    end
  end
end
