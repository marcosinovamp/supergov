class RenameFotoToLogo < ActiveRecord::Migration[7.0]
  def change
    rename_column :decks, :foto, :logo
  end
end
