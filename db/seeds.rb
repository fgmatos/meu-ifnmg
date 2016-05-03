require 'transparencia.gov.br.rb'
require "import"

# DataImport.new(type, year_range, month_range, options = nil)

# tasks - list of task to import
  # taskname: um nome para identificar a tarefa. Ex.: :task01, ou :importando2015
  # => type: dado a importar -> :diarias, :servidores ou :remuneracoes
  # => year_range: intevalo de anos. Ex: 2011..2015
  # => month_range: intervalo de meses. Ex: 1..2  ou :all para todos os meses
  # => options: { } - Paramentros para leitura do CSV
  # => filter_colums - colunas no CSV para filtrar os dados


# tasks = { 
        # # # DIARIAS
        # # :t01 => {
            # # :type => :diarias, 
            # # :year_range => 2011..2015, 
            # # :month_range => :all # equivalente a 1..12 
        # # }, 
        # # :t02 => {
            # # :type => :diarias, 
            # # :year_range => 2016, 
            # # :month_range => 01..03
        # # }, 
        # # SERVIDORES
        # :t03 => { 
            # :type => :servidores, 
            # :year_range => 2013..2015, 
            # :month_range => :all
        # },
        # :t04 => {
            # :type => :servidores, 
            # :year_range => 2016, 
            # :month_range => 1..3
            # # ,
            # # :options => {:quote_char => "|"}
        # },
        # # # REMUNERACOES (servidores)
        # # :t05 => {
            # # :type => :remuneracoes, 
            # # :year_range => 2013..2015, 
            # # :month_range => :all
        # # },
        # # :t06 => {
            # # :type => :remuneracoes, 
            # # :year_range => 2016, 
            # # :month_range => 01..03
        # # }
  # }
#   
# # to log the execution uncomment the following lines
# started_in = Time.now.strftime("%d-%m-%Y-%H-%M-%S")
# $stdout = File.new("import.log","w")
# $stdout.sync = true
# 
# # A cada TASK | key, value |
# tasks.each do | task, options |
    # puts "##{task}-> Deseja importar: '#{options[:type].upcase}' (ANOS->#{options[:year_range]}) (MESES->#{options[:month_range]}) do IFNMG ? (y/n) ou (s/n)"
    # # choice = STDIN.gets.chomp
    # # if (choice.upcase == "Y" || choice.upcase == "S")
      # import = DataImport.new(options[:type], options[:year_range], options[:month_range], options[:options])
      # # import.execute
      # import.log(:nome => "FABIANO GONCALVES MATOS")
      # import.run_test
    # # end
# end
# 
# # Renomear o arquivo após terminar a importacao
# File.rename("import.log", "import#{started_in}.log")


#import-contratos
# descomentar daqui para baixo para importar contratos. 
# => PRECISA SER MELHORADO!!!

# link_base = "http://www3.transparencia.gov.br/TransparenciaPublica/jsp/contratos/"
# contratos ||= APIGov.new(:contratos)
# @contratos ||= contratos.getContratos
# 
# @contratos.each do | num, valores |
  # c = Contrato.new
#   
  # c.numero = valores[:numero]
  # c.ano = valores[:numero].split("/").last
  # c.modalidade = valores[:modalidade]
  # c.situacao = valores[:situacao]
  # c.contratado = valores[:contratado]
  # c.contratado_cnpj = valores[:contratado].split(" - ").first
#   
  # # c.contratado_nome
#   
  # c.unidade = valores[:unidade]
  # c.unidade_id = valores[:unidade].split(" - ").last
  # c.unidade_nome = valores[:unidade].split(" - ").first
#   
  # c.objeto = valores[:objeto]
#   
  # c.link = (link_base.to_s + valores[:link_detalhes].to_s.split('"').second.gsub("amp;", "") )
  # c.ref = num+1 
#   
  # c.save!
#   
# end


# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel', city: cities.first)
# 
