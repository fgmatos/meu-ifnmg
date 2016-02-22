class CreateServidors < ActiveRecord::Migration
  def change
    create_table :servidors do |t|
      t.string :id_servidor_portal
      t.string :nome
      t.string :cpf
      t.string :matricula
      t.string :descricao_cargo
      t.string :classe_cargo
      t.string :padrao_cargo
      t.string :nivel_cargo
      t.string :sigla_funcao
      t.string :nivel_funcao
      t.string :uorg_lotacao
      t.string :cod_org_lotacao
      t.string :cod_org_exercicio
      t.string :situacao_vinculo
      t.string :jornada_de_trabalho
      t.date :data_ingresso_cargofuncao
      t.date :data_ingresso_orgao
      t.string :documento_ingresso_servicopublico
      t.date :data_diploma_ingresso_servicopublico
      t.string :diploma_ingresso_orgao
      
      t.timestamps null: false
    end
  end
end
