class CreateRemuneracaos < ActiveRecord::Migration
  def change
    create_table :remuneracoes do |t|
      t.string :ano
      t.string :mes
      t.string :id_servidor_portal
      t.string :cpf
      t.string :nome
      t.string :remuneracao_basica_bruta_rs
      t.string :abate_teto_rs
      t.string :gratificacao_natalina_rs
      t.string :abate_teto_gratificacao_natalina
      t.string :ferias
      t.string :outras_remuneracoes_eventuais
      t.string :irrf
      t.string :pss_rpgs
      t.string :pensao_militar
      t.string :fundo_de_saude
      t.string :demais_deducoes
      t.string :remuneracao_apos_deducoes
      t.string :verbas_indenizatorias_civil
      t.string :verbas_indenizatorias_militar
      t.string :total_verbas_indenizatorias
      t.string :total_honorarios

      t.timestamps null: false
    end
  end
end
