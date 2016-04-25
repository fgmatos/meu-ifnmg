
require "import"

# DataImport.new(type, year_range, month_range, options = nil)

# tasks - list of task to import
  # taskname: um nome para identificar a tarefa. Ex.: :task01, ou :importando2015
  # => type: dado a importar -> :diarias, :servidores ou :remuneracoes
  # => year_range: intevalo de anos. Ex: 2011..2015
  # => month_range: intervalo de meses. Ex: 1..2  ou :all para todos os meses
  # => options: { } - Paramentros para leitura do CSV
  # => filter_colums - colunas no CSV para filtrar os dados


tasks = { 
        :t01 => {
            :type => :diarias, 
            :year_range => 2011..2015, 
            :month_range => :all # equivalente a 1..12 
        }, 
        :t02 => {
            :type => :diarias, 
            :year_range => 2016, 
            :month_range => 01..03
        }, 
        :t03 => { 
            :type => :servidores, 
            :year_range => 2014..2015, 
            :month_range => :all
        },
        :t04 => {
            :type => :servidores, 
            :year_range => 2016, 
            :month_range => 1..3
            # ,
            # :options => {:quote_char => "|"}
        },
        :t05 => {
            :type => :remuneracoes, 
            :year_range => 2015, 
            :month_range => 12
        }
  }
  
# to log the execution uncomment the following lines
# $stdout = File.new("import-log#{Time.new}.log","w")
# $stdout.sync = true

# A cada TASK | key, value |
tasks.each do | task, options |
    puts "##{task}-> Deseja importar dados de '#{options[:type].upcase}' (ANOS->#{options[:year_range]}) (MESES->#{options[:month_range]}) do IFNMG ? (y/n) ou (s/n)"
    choice = STDIN.gets.chomp
    if (choice.upcase == "Y" || choice.upcase == "S")
      import = DataImport.new(options[:type], options[:year_range], options[:month_range], options[:options])
      import.execute
      # import.run_test
    end
end

# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel', city: cities.first)
# 
