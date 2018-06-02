class CreatePageCategories < ActiveRecord::Migration
  def change
    create_table :page_categories do |t|
      t.column :title,                    :string
      t.column :body,                     :text
      t.column :sort_order,               :integer
      t.column :page_category_id,         :integer
      t.column :department_id,            :integer
      t.column :admin_id,                 :integer
      t.column :apikey,                   :string
      t.column :url_slug,                 :string

      t.timestamps null: false
    end

    add_attachment :page_categories, :cover_image

  end
end
