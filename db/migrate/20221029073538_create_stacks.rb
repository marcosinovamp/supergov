class CreateStacks < ActiveRecord::Migration[7.0]
  def change
    create_table :stacks do |t|
      t.text :cards

      t.timestamps
    end
  end
end
