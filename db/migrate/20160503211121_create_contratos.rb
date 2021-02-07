class CreateContratos < ActiveRecord::Migration
  def change
    create_table :contratos do |t|
      t.string :ano
      t.string :numero
      t.string :modalidade
      t.string :situacao
      t.string :contratado
      t.string :contratado_cnpj
      t.string :contratado_nome
      
      t.string :unidade
      t.string :unidade_id
      t.string :unidade_nome
      
      t.string :objeto
      
      t.string :link
      t.string :ref

      t.timestamps null: false
    end
  end
end
