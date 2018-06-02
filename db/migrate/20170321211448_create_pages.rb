class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.column :title,                      :string
      t.column :body,                       :text
      t.column :page_category_id,           :integer
      t.column :department_id,              :integer
      t.column :template,                   :string
      t.column :admin_id,                   :integer
      t.column :url_slug,                   :string
      t.column :apikey,                     :string
      t.column :sort_order,                 :integer


      t.timestamps null: false
    end

    add_attachment :pages, :cover_image
  end
end
