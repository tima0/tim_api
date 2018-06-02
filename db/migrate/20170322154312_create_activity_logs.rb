class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.column :activity,               :string

      t.timestamps null: false
    end
  end
end
