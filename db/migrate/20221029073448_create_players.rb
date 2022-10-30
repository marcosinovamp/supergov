class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :nature
      t.string :nome

      t.timestamps
    end
  end
end
