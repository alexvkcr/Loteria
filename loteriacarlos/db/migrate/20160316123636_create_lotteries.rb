class CreateLotteries < ActiveRecord::Migration
  def change
    create_table :lotteries do |t|
      t.string :email
      t.string :contraseña
      t.string :usuario
      t.integer :luckynumber
      t.string :genero

      t.timestamps null: false
    end
  end
end
