class AddNumberToDeck < ActiveRecord::Migration[7.0]
  def change
    add_column :decks, :number, :integer
    add_column :decks, :identificacao, :string
  end
end
