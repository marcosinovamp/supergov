class AddRefs < ActiveRecord::Migration[7.0]
  def change
    add_reference :cards, :deck
    add_reference :hands, :game
    add_reference :stacks, :game
    add_reference :stacks, :player
  end
end
