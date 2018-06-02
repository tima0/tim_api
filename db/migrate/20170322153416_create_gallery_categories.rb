class CreateGalleryCategories < ActiveRecord::Migration
  def change
    create_table :gallery_categories do |t|
      t.column :title,                    :string
      t.column :description,              :text
      t.column :admin_id,                 :integer

      t.timestamps null: false
    end
  end
end
