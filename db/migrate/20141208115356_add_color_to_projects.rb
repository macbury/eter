class AddColorToProjects < ActiveRecord::Migration
  def up
    add_column :projects, :color_hex, :string, null: false

    Project.all.each do |project|
      project.generate_colors!
      project.save
    end
  end

  def down
    remove_column :projects, :color_hex

  end
end
