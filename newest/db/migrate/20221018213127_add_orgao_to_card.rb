class AddOrgaoToCard < ActiveRecord::Migration[7.0]
  def change
    add_reference :cards, :orgao
    add_column :cards, :foto, :string
  end
end
