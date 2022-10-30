class AddFotosToDeck < ActiveRecord::Migration[7.0]
  def change
    add_column :decks, :foto, :string
    remove_column :cards, :foto
  end
end
