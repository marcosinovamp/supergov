class CorrectCardsOnStacks < ActiveRecord::Migration[7.0]
  def change
    change_column :stacks, :cards, :text
  end
end
