class CreateOrgaos < ActiveRecord::Migration[7.0]
  def change
    create_table :orgaos do |t|
      t.string :nome
      t.integer :siorg

      t.timestamps
    end
  end
end
