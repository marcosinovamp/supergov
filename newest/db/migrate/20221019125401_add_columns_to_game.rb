class AddColumnsToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :player1, :integer
    add_column :games, :player2, :integer
    add_column :games, :winner, :integer
  end
end
