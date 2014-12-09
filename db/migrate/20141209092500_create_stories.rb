class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.integer :project_id
      t.integer :requested_by_id
      t.integer :owner_id
      t.string :story_type
      t.integer :estimate
      t.string :title
      t.text :description
      t.string :state
      t.datetime :accepted_at

      t.timestamps
    end
  end
end
