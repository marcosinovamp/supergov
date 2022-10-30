class AddNaoEstimadoToDeck < ActiveRecord::Migration[7.0]
  def change
    add_column :decks, :qtd_nao_estimados, :integer
  end
end
