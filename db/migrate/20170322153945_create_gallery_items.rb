class CreateGalleryItems < ActiveRecord::Migration
  def change
    create_table :gallery_items do |t|
      t.column :title,              :string
      t.column :description,        :text
      t.column :status,             :string
      t.column :admin_id,           :integer

      t.timestamps null: false
    end

    add_attachment :gallery_items, :image

  end
end
