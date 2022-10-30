class AddJogoToHand < ActiveRecord::Migration[7.0]
  def change
    add_reference :hands, :game
  end
end
