class AddNameToPlayer < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :nome, :string
  end
end
