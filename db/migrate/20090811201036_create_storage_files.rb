class CreateStorageFiles < ActiveRecord::Migration
  def self.up
    create_table :storage_files do |t|
      t.integer :storage_section_id
      t.integer :user_id
      t.string :zip
      t.string :name

      t.string    :file_file_name
      t.string    :file_content_type
      t.integer   :file_file_size
      t.datetime  :file_updated_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :storage_files
  end
end
