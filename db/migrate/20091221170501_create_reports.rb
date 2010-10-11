class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports, :force => true do |t|
      t.integer :user_id
      t.string :zip
      
      t.string :title
      t.text :description
      t.text :content
      t.text :prepared_content
      
      t.string :state, :default=>"hidden"
      t.text :settings
      
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt

      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end
