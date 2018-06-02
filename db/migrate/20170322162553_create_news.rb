class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.column :title,            :string
      t.column :content,          :text
      t.column :admin_id,         :integer
      t.column :apikey,           :string
      t.column :url_slug,         :string

      t.timestamps null: false
    end

    add_attachment :news, :image

  end
end
