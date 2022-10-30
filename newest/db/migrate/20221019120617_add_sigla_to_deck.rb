class AddSiglaToDeck < ActiveRecord::Migration[7.0]
  def change
    add_column :decks, :sigla, :string
  end
end
