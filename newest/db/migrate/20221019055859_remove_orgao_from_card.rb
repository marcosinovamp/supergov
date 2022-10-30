class RemoveOrgaoFromCard < ActiveRecord::Migration[7.0]
  def change
    remove_column :cards, :orgao
    add_column :cards, :unidade, :string
    add_column :cards, :duracao, :integer
  end
end
