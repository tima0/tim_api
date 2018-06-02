class CreateCitizenRequests < ActiveRecord::Migration
  def change
    create_table :citizen_requests do |t|
      t.column :user_id,                    :integer
      t.column :department_id,              :integer
      t.column :citizen_request_id,         :integer
      t.column :title,                      :string
      t.column :request,                    :text
      t.column :status,                     :string

      t.timestamps null: false
    end
  end
end
