# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# unidades gestoras do IFNMG [reitoria, salinas, januaria, montes-claros, arinos, almenara, pirapora, aracuai]
ifnmg_ugs =  ["158121", "158377", "158378", "158437", "158438", "158439", "158440", "158441"]

# codigo do Orgao - IFNMG
ifnmg_uorg = ["26410"]


puts "Deseja importar os daods dos SERVIDORES do IFNMG ? (y/n) ou (s/n)"
resposta = STDIN.gets.chomp

if (resposta.upcase == "Y" || resposta.upcase == "S")

    #importando informaçoes dos arquivos CSV
    require 'csv'
    
    diretorio = Rails.root.join("app","data","servidores","201501_Servidores").to_s
    
    count = 0
    skiped = 0
    all = 0
    
    quote_chars = %w( ' " | ~ ã ^ & * )
    
    for ano in 2015..2015
      for mes in 01..01
        filename = (ano.to_s + mes.to_s.rjust(2,'0') + "31_Cadastro.csv").to_s
        CSV.foreach( (diretorio.to_s + ("/").to_s + filename.to_s), headers: true, encoding:'windows-1250', col_sep: "\t", header_converters: :symbol) do |row|  #, :quote_char => quote_chars.shift
          # convertendo o resultado para um Hash
          data = row.to_hash
          # se o servidor esta lotado ou em exercicio no IFNMG
          if ( (ifnmg_uorg.include? data[:cod_org_lotacao]) || (ifnmg_uorg.include? data[:cod_org_exercicio]) )
            
            
            if (! Servidor.exists?(:id_servidor_portal => data[:id_servidor_portal]))
                
                
                if (Servidor.exists?(:cpf => data[:cpf]))
                
                    sc = Servidor.select(:nome, :cpf).where(:cpf => data[:cpf]).pluck(:nome, :cpf)
                    
                    puts "Conflito: :cpf!"
                    puts "Cadastrado -> " + sc.inspect
                    puts "importando -> " + data[:nome] + data[:cpf]
                    
                    puts "\n Importar novo registro (s/n) ou (y/n)"
                    op = STDIN.gets.chomp
                
                    if ( op.upcase == "S" || op.upcase == "Y" )
                  
                        count = count + 1
                        s = Servidor.new
                        s.id_servidor_portal = data[:id_servidor_portal].to_i
                        s.nome = data[:nome]
                        s.cpf = data[:cpf]
                        s.matricula = data[:matricula]
                        s.descricao_cargo = data[:descricao_cargo]
                        s.classe_cargo = data[:classe_cargo]
                        s.padrao_cargo = data[:padrao_cargo]
                        s.nivel_cargo = data[:nivel_cargo]
                        s.sigla_funcao = data[:sigla_funcao]
                        s.nivel_funcao = data[:nivel_funcao]
                        s.cod_org_lotacao = data[:cod_org_lotacao]
                        s.cod_org_exercicio = data[:cod_org_exercicio]
                        s.situacao_vinculo = data[:situacao_vinculo]
                        s.jornada_de_trabalho = data[:jornada_de_trabalho]
                        s.data_ingresso_cargofuncao = data[:data_ingresso_cargofuncao]
                        s.data_ingresso_orgao = data[:data_ingresso_orgao]
                        s.documento_ingresso_servicopublico = data[:documento_ingresso_servicopublico]
                        s.data_diploma_ingresso_servicopublico = data[:data_diploma_ingresso_servicopublico]
                        s.diploma_ingresso_orgao = data[:diploma_ingresso_orgao]
                        
                        s.save!
                        puts ano.to_s + "/" + mes.to_s + " - Registro Nº: " +count.to_s
                    end
                else
                  
                        count = count + 1
                        s = Servidor.new
                        s.id_servidor_portal = data[:id_servidor_portal].to_i
                        s.nome = data[:nome]
                        s.cpf = data[:cpf]
                        s.matricula = data[:matricula]
                        s.descricao_cargo = data[:descricao_cargo]
                        s.classe_cargo = data[:classe_cargo]
                        s.padrao_cargo = data[:padrao_cargo]
                        s.nivel_cargo = data[:nivel_cargo]
                        s.sigla_funcao = data[:sigla_funcao]
                        s.nivel_funcao = data[:nivel_funcao]
                        s.cod_org_lotacao = data[:cod_org_lotacao]
                        s.cod_org_exercicio = data[:cod_org_exercicio]
                        s.situacao_vinculo = data[:situacao_vinculo]
                        s.jornada_de_trabalho = data[:jornada_de_trabalho]
                        s.data_ingresso_cargofuncao = data[:data_ingresso_cargofuncao]
                        s.data_ingresso_orgao = data[:data_ingresso_orgao]
                        s.documento_ingresso_servicopublico = data[:documento_ingresso_servicopublico]
                        s.data_diploma_ingresso_servicopublico = data[:data_diploma_ingresso_servicopublico]
                        s.diploma_ingresso_orgao = data[:diploma_ingresso_orgao]
                        
                        s.save!
                        puts ano.to_s + "/" + mes.to_s + " - Registro Nº: " +count.to_s
                  
                  
                end
            else # if !Servidor.exists?
              skiped = skiped + 1
              puts "Skiped -> id_servidor_portal: " + data[:id_servidor_portal] + " arleady imported! - " + data[:nome]
            end # if !Servidor.exists?
          
          else  # if UORG
              all = all + 1
              # puts "Skiped -> id_servidor_portal: " + data[:id_servidor_portal] + " not belongs to IFNMG! - " + data[:nome] + ", " + data[:cpf]
          end # if UORG
          
        end # CSV.foreach
        puts "-----------------------------"
        puts "Imported :" + ano.to_s + "/" + mes.to_s 
        puts "-----------------------------"
      end # for mes
    end # for ano
    
    puts "-----------------------------"
    puts "Data loaded :" + count.to_s + " records"
    puts "Skiped IFNMG Records: " + skiped.to_s
    puts "Total records in CSV File: " + all.to_s
    puts "-----------------------------"
  
end # if









puts "Deseja importar os dados de Diárias do IFNMG (2011 à 2015)? (y/n) ou (s/n)"
resposta = STDIN.gets.chomp

if (resposta.upcase == "Y" || resposta.upcase == "S")

    #importando dados de DIARIAS dos arquivos CSV
    require 'csv'
    
    diretorio = Rails.root.join("app","data","diarias").to_s
    
    count = 0
    for ano in 2011..2015
      for mes in 1..12
        filename = (ano.to_s + mes.to_s.rjust(2,'0') + "_Diarias.csv").to_s
        CSV.foreach( (diretorio.to_s + ("/").to_s + filename.to_s), headers: true, encoding:'windows-1250', col_sep: "\t", header_converters: :symbol) do |row|
          # convertendo o resultado para um Hash
          data = row.to_hash
          # pegamos apenas as diarias do IFNMG e seus campi
          # se a linha tem o codigo da unidade gestora 
          if ( ifnmg_ugs.include? data[:cdigo_unidade_gestora] )
            count = count + 1
            d = Diaria.new
            d.id_unidade = data[:cdigo_unidade_gestora].to_i
            d.nome_unidade = data[:nome_unidade_gestora]
            d.cpf = data[:cpf_favorecido] 
            d.nome = data[:nome_favorecido]
            d.num_doc = data[:documento_pagamento] 
            d.data = data[:data_pagamento]
            d.valor = data[:valor_pagamento].to_f
            
            d.save!
            puts ano.to_s + "/" + mes.to_s + " - Registro Nº: " +count.to_s
          end
        end
        puts "-----------------------------"
        puts "Imported :" + ano.to_s + "/" + mes.to_s 
        puts "-----------------------------"
      end
    end
    
    puts "-----------------------------"
    puts "Data loaded :" + count.to_s + " records"
    puts "-----------------------------"
  
end # if
