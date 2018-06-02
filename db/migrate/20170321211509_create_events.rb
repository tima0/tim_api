class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.column :title,                  :string
      t.column :description,            :string
      t.column :date,                   :date
      t.column :time,                   :string
      t.column :status,                 :string
      t.column :admin_id,               :integer

      t.timestamps null: false
    end

    add_attachment :events, :cover_image

  end
end
