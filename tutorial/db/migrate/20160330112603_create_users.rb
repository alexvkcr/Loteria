class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user
      t.string :password
      t.boolean :admin, default: :false
      t.integer :numero

      t.timestamps null: false
    end
  end
end
