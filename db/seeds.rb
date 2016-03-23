
require "import"

# DataImport.new(type, year_range, month_range, options = nil)

  # => type: dado a importar: "diarias" ou "servidores"
  # => year_range: intevalo de anos. Ex: 2011..2015
  # => month_range: intervalo de meses. Ex: 1..2  ou :all para todos os meses
  # => options: { } - Paramentros para leitura do CSV
  # => filter_colums - colunas no CSV para filtrar os dados

import_conf = { 
        :diarias => { 
            :year_range => 2011..2015, 
            :month_range => :all #01..01 
        }, 
        :servidores => { 
            :year_range => 2015..2015, 
            :month_range => 01..01 #[01, 10, 11, 12]  
        } 
  }

import_conf.each do | type, options |
    puts "Deseja importar dados de '" + type.to_s.upcase + "' do IFNMG ? (y/n) ou (s/n)"
    choice = STDIN.gets.chomp
    if (choice.upcase == "Y" || choice.upcase == "S")
      import = DataImport.new(type, options[:year_range], options[:month_range])
      import.execute
      # import.run_test
    end
end

# puts "Deseja importar dados de DIARIAS do IFNMG ? (y/n) ou (s/n)"
# resposta = STDIN.gets.chomp
# 
# if (resposta.upcase == "Y" || resposta.upcase == "S")
  # diarias = DataImport.new(:diarias, 2011..2014, :all)
  # diarias.execute
# end
# 
# puts "Deseja importar dados de SERVIDORES do IFNMG ? (y/n) ou (s/n)"
# resposta = STDIN.gets.chomp
# 
# if (resposta.upcase == "Y" || resposta.upcase == "S")
  # servidores = DataImport.new(:servidores, 2015..2015, 1..1)
  # servidores.execute
# end
  

# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel', city: cities.first)
# 
