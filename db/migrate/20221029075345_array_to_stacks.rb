class ArrayToStacks < ActiveRecord::Migration[7.0]
  def change
    change_column :stacks, :cards, :text, array: true, default: [], using: "(string_to_array(cards, ','))"
  end
end
