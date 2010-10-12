class UpdateFields < ActiveRecord::Migration
  def self.up
    rename_column :storage_sections, :name, :title 
    rename_column :storage_files, :name, :title
  end

  def self.down
    rename_column :storage_sections, :title, :name
    rename_column :storage_files, :title, :name
  end
end
