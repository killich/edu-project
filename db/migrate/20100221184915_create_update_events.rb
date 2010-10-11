class CreateUpdateEvents < ActiveRecord::Migration
  def self.up
    create_table :update_events do |t|
      t.integer :user_id
      t.string :zip
      
      t.integer :event_object_id
      t.string :event_object_type
      
      t.string :event_object_title
      t.string :event_object_zip
      
      t.string :event_type

      t.timestamps
    end
  end

  def self.down
    drop_table :update_events
  end
end
