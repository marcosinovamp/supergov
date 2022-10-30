class CreateHands < ActiveRecord::Migration[7.0]
  def change
    create_table :hands do |t|
      t.integer :cardp1
      t.integer :cardp2
      t.integer :winner

      t.timestamps
    end
  end
end
