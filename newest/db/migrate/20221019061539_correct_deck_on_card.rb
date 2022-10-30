class CorrectDeckOnCard < ActiveRecord::Migration[7.0]
  def change
    remove_column :cards, :orgao_id
    add_reference :cards, :deck
  end
end
