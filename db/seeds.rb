# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#importando dados de DIARIAS dos arquivos CSV

require 'csv'

diretorio = Rails.root.join("app","data","diarias").to_s

# unidades gestoras do IFNMG [reitoria, salinas, januaria, montes-claros, arinos, almenara, pirapora, aracuai]
ifnmg_ugs =  ["158121", "158377", "158378", "158437", "158438", "158439", "158440", "158441"]
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
