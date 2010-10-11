class CreateStorageSections < ActiveRecord::Migration
  def self.up
    create_table :storage_sections do |t|
      t.integer :user_id
      t.string :zip
      t.string :name
      t.integer :files_count
      t.integer :files_size
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :storage_sections
  end
end
