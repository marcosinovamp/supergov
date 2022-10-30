class CreateDecks < ActiveRecord::Migration[7.0]
  def change
    create_table :decks do |t|
      t.string :nome
      t.integer :siorg
      t.string :logo
      t.string :sigla
      t.integer :avaliacoes
      t.float :aprovacao
      t.float :media_etapas
      t.float :digitalizacao
      t.float :porc_botao_iniciar
      t.float :media_duracao
      t.integer :qtd_nao_estimados
      t.integer :number
      t.string :identificacao

      t.timestamps
    end
  end
end
