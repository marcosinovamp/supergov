class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :nome
      t.float :digitalizacao
      t.boolean :botao_iniciar
      t.integer :api_id
      t.float :aprovacao
      t.integer :avaliacoes
      t.integer :etapas
      t.integer :tempo
      t.string :unidade
      t.integer :duracao
      t.string :identificacao
      t.integer :number

      t.timestamps
    end
  end
end
