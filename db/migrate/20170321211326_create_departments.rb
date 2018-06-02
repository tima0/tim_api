class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.column :name,                     :string
      t.column :description,              :string
      t.column :body,                     :text
      t.column :status,                   :string
      t.column :sort_order,               :string
      t.column :url_slug,                 :string
      t.column :admin_id,                 :integer
			t.column :apikey,										:string

      t.timestamps null: false
    end

    add_attachment :departments, :cover_image
  end
end
