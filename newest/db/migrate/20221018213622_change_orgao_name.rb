class ChangeOrgaoName < ActiveRecord::Migration[7.0]
  def change
    rename_table :orgaos, :decks
  end
end
