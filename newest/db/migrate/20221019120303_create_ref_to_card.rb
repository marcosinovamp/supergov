class CreateRefToCard < ActiveRecord::Migration[7.0]
  def change
    add_column :cards, :identificacao, :string
  end
end
