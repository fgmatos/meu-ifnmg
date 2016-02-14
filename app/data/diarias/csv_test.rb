# script para testar a leitura dos dados nos arquivos CSV baixados do portal da transparencia (2011-2015)
# =>  http://www.portaltransparencia.gov.br/downloads/

require 'csv'

# unidades gestoras do IFNMG
# [reitoria, salinas, januaria, montes-claros, arinos, almenara, pirapora, aracuai]
ifnmg_ugs =  ["158121", "158377", "158378", "158437", "158438", "158439", "158440", "158441"]
# contagem de ocorrencias de diarias em unidades do IFNMG
count = 0
# somatorio dos valores gastos no periodo
total_gasto = 0

for ano in 2011..2015
  for mes in 1..12
    CSV.foreach( ano.to_s + mes.to_s.rjust(2,'0') + "_Diarias.csv", headers: true, encoding:'windows-1250', col_sep: "\t", header_converters: :symbol) do |row|
      # convertendo o resultado para um Hash
      data = row.to_hash
      # pegamos apenas as diarias do IFNMG e seus campi
      # se a linha tem o codigo da unidade gestora 
      if ( ifnmg_ugs.include? data[:cdigo_unidade_gestora] )
        count = count + 1
        puts "\nUnidade Gestora: " + data[:cdigo_unidade_gestora], 
             "Nome da Unidade: " + data[:nome_unidade_gestora], 
             "CPF do Favorecido: " + data[:cpf_favorecido], 
             "Nome: " + data[:nome_favorecido],
             "Nº Documento: " + data[:documento_pagamento], 
             "Data pagamento: " + data[:data_pagamento], 
             "valor: R$" + data[:valor_pagamento]
        total_gasto = total_gasto + data[:valor_pagamento].to_f
      end
    end
  end
end
puts "\nTotal de Registros do IFNMG: " + count.to_s
puts "Valor Total gasto: R$" + total_gasto.to_s

