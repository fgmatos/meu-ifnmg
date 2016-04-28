# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160426135400) do

  create_table "contatos", force: :cascade do |t|
    t.string   "nome"
    t.string   "email"
    t.text     "mensagem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diaria", force: :cascade do |t|
    t.string   "id_unidade"
    t.string   "nome_unidade"
    t.string   "cpf"
    t.string   "nome"
    t.string   "num_doc"
    t.date     "data"
    t.string   "valor"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "traking_info"
  end

  create_table "remuneracoes", force: :cascade do |t|
    t.string   "ano"
    t.string   "mes"
    t.string   "id_servidor_portal"
    t.string   "cpf"
    t.string   "nome"
    t.string   "remuneracao_basica_bruta_rs"
    t.string   "abate_teto_rs"
    t.string   "gratificacao_natalina_rs"
    t.string   "abate_teto_gratificacao_natalina"
    t.string   "ferias"
    t.string   "outras_remuneracoes_eventuais"
    t.string   "irrf"
    t.string   "pss_rpgs"
    t.string   "pensao_militar"
    t.string   "fundo_de_saude"
    t.string   "demais_deducoes"
    t.string   "remuneracao_apos_deducoes"
    t.string   "verbas_indenizatorias_civil"
    t.string   "verbas_indenizatorias_militar"
    t.string   "total_verbas_indenizatorias"
    t.string   "total_honorarios"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "traking_info"
  end

  create_table "servidors", force: :cascade do |t|
    t.string   "id_servidor_portal"
    t.string   "nome"
    t.string   "cpf"
    t.string   "matricula"
    t.string   "descricao_cargo"
    t.string   "classe_cargo"
    t.string   "padrao_cargo"
    t.string   "nivel_cargo"
    t.string   "sigla_funcao"
    t.string   "nivel_funcao"
    t.string   "uorg_lotacao"
    t.string   "cod_org_lotacao"
    t.string   "cod_org_exercicio"
    t.string   "situacao_vinculo"
    t.string   "jornada_de_trabalho"
    t.date     "data_ingresso_cargofuncao"
    t.date     "data_ingresso_orgao"
    t.string   "documento_ingresso_servicopublico"
    t.date     "data_diploma_ingresso_servicopublico"
    t.string   "diploma_ingresso_orgao"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "traking_info"
  end

end
