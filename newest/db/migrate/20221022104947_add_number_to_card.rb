class AddNumberToCard < ActiveRecord::Migration[7.0]
  def change
    add_column :cards, :number, :integer
  end
end
