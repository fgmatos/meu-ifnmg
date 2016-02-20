class CreateDiaria < ActiveRecord::Migration
  def change
    create_table :diaria do |t|
      t.string :id_unidade
      t.string :nome_unidade
      t.string :cpf
      t.string :nome
      t.string :num_doc
      t.string :data
      t.float :valor

      t.timestamps null: false
    end
  end
end
