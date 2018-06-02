class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.column :first_name,                       :string
      t.column :last_name,                        :string
      t.column :email,                            :string
      t.column :password_hash,                    :string
      t.column :password_salt,                    :string
      t.column :apikey,                           :string
      t.column :password_recover,                 :string
      t.column :status,                           :string

      t.timestamps null: false
    end

    add_attachment :employees, :avatar

  end
end
