class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.column :title,              :string
      t.column :description,        :text
      t.column :file_type,          :string
      t.column :file_url,           :string
      t.column :admin_id,           :integer
      t.column :apikey,             :string
      t.column :sort_order,         :integer

      t.timestamps null: false
    end

  end
end
