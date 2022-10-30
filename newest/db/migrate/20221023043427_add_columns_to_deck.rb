class AddColumnsToDeck < ActiveRecord::Migration[7.0]
  def change
    add_column :decks, :avaliacoes, :integer
    add_column :decks, :aprovacao, :float
    add_column :decks, :media_etapas, :float
    add_column :decks, :digitalizacao, :float
    add_column :decks, :porc_botao_iniciar, :float
    add_column :decks, :media_duracao, :float
  end
end
