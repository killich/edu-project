class ChangePageFields < ActiveRecord::Migration
  def self.up
    #add_column :pages, :state, :string, :default=>"hidden"
    #rename_column :pages, :display, :display_state
  end

  def self.down
    #remove_column :pages, :state
    #rename_column :pages, :display_state, :display
  end
end
