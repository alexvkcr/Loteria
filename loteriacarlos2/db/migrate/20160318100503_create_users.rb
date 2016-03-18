class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :usuario
      t.string :email
      t.string :password
      t.boolean :admin , default: :false

      t.timestamps null: false
    end
  end
end
