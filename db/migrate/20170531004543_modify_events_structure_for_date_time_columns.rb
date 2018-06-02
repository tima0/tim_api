class ModifyEventsStructureForDateTimeColumns < ActiveRecord::Migration
  def change
    # Changing structure to allow for more efficient searching of dates
    change_column :events, :date, :datetime
    rename_column :events, :date, :start_time
    add_column :events, :end_time, :datetime
    remove_column :events, :time

    add_column :events, :apikey, :string
    add_column :events, :url_slug, :string

    # Optimize searches (we anticipate many more searches than inserts)
    add_index :events, :start_time
    add_index :events, :end_time
    add_index :events, :status
    add_index :events, :admin_id
    add_index :events, :apikey
  end
end
