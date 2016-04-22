

require "csv"

# Class DataImport
# => @type: Tipo de dado que será importado.
# => @name:  nome final do arquivi csv baixado para importacao - Baseado no @type
# => @diretorio: pasta padrão onde os arquivos CSV foram baixados + pasta do dado a ser importado
#   

class DataImport 
  # codigo do orgao IFNMG
  UORG = 26410
  
  # unidades gestoras do IFNMG 
  # => reitoria - 158121
  # => salinas - 158377
  # => januaria
  # => montes-claros
  # => arinos
  # => almenara
  # => pirapora
  # => aracuai
  UGS =  ["158121", "158377", "158378", "158437", "158438", "158439", "158440", "158441"]
  
  # if TRUE show report  
  DEBUG = TRUE
  
  @@instances = 0
    
  # constructor 
  def initialize(type, year_range, month_range, options = nil)
    # registros processados
    @records_processed = 0
    
    # registros importados
    @records_imported = 0
    
    # Modo de teste - simula a importacao sem salvar no banco
    @test_mode = FALSE
    
    # registros processados em cada arquivo
    @records_each_file = 0
    
    # hash para armazenar a quantidade de registros em cada arquivo. 
    # =>  Ex.:@files[filename] = @records_each_file
    @files = Hash.new
    
    # tipo de dado a ser importado
    # =>  suportados :diarias e :servidores
    @type = type.to_sym
    
    # @name =  getGOV_file_str
    
    # diretorio base para a importacao de dados
    # => Ex.: app/data/servidores
    @diretorio = Rails.root.join("app","data",@type.to_s).to_s + "/"
    
    @year_range = validate_range(year_range)
    
    if month_range == :all
      @months_range = 1..12  
    else
      @months_range = validate_range(month_range)
    end
    
    # default options
    @options = {headers: true, encoding:'windows-1250', col_sep: "\t", header_converters: :symbol}
    
    # if user seted personal options include 
    if (!options.nil?)
      @options.merge!(options)          
    end
    
    # if (options.nil?)
      # @options = {headers: true, encoding:'windows-1250', col_sep: "\t", header_converters: :symbol}
    # else
      # @options = options          
    # end
    
    @@instances += 1
  end
  
  def execute
    @year_range.each do |year|
      for month in @months_range
        @filename = getFilename(month, year)
        @files[ @filename.to_sym ] = 0 
        process(@filename)
      end
    end
    if (DEBUG)
      print_debug_info
    end
  end
  
  def to_s
    "DataImport: " + @@instances.to_s
  end
  
  def run_test
    @test_mode = TRUE
    execute
  end
    
  private
  
  def process(file)
    @records_each_file = 0
    
    if File.exist?(file)
      
      if (DEBUG)
        puts "importing: " + file.to_s
      end
      
      # this block is equivalent to try..except 
      begin
        
        temp = File.read(file, encoding:"ISO-8859-1")
        
        # remove 'aspas' do arquivo
        @file = strip(temp)
        
        # converte o arquivo para CSV
        @csvfile = parse(@file)
        
        # CSV.foreach(file, @options) do |row|
        @csvfile.each do |row|
          # convert o registro para um hash
          data = row.to_hash
          @records_processed +=  1
          # testa se o registro tiver dados relacionados ao IFNMG
          if belongsIFNMG(data)
            if !@test_mode
              import(data)         
            end
            @records_each_file += 1
            @records_imported +=  1     
          end
        end # end foreach
      rescue => ex
        puts "Erro na leitrua do arquivo: " + file.to_s + " - " + ex.message
      end
      @files[ @filename.to_sym ] = @records_each_file 
      
    else # file not exits
      puts "Error on importing: " + file.to_s + "!. File no found."
      # exit
    end # if file.exist?
    
  end
  
  def parse(file)
    CSV.parse(file, @options)
  end
  
  def strip(file)
    file.gsub('"',"'")
  end
  
  def belongsIFNMG(data)
    case @type
      when :diarias then UGS.include? data[:cdigo_unidade_gestora]
      when :servidores then 
        
        if ( (UORG.to_s == data[:cod_org_lotacao]) || (UORG.to_s == data[:cod_org_exercicio]) )
          if (FACADE.Servidor.exists?(:cpf => data[:cpf]))
            compare_records(data)
          else 
            return TRUE
          end
          
        end
        
      else "unknow filter"
    end
  end
  
  def compare_records(data)
    s = FACADE.Servidor.where(cpf: data[:cpf]).take
    # saved.each do |s|
      if s.cpf == data[:cpf] && s.nome == data[:nome]
        
        s.update( extract_data(data) )
        return FALSE
      else 
        return TRUE
      end
    # end # end saved.each
  end
  
  def import(data)
    
    @model = case @type
      when :diarias
        @model = FACADE.Diaria
      when :servidores
        @model = FACADE.Servidor
    end
       
    obj = @model.new( transform_data( extract_data(data) ) )
    # obj.id_unidade = data[:cdigo_unidade_gestora].to_i
    # obj.nome_unidade = data[:nome_unidade_gestora]
    # obj.cpf = data[:cpf_favorecido] 
    # obj.nome = data[:nome_favorecido]
    # obj.num_doc = data[:documento_pagamento] 
    # obj.data = data[:data_pagamento]
    # obj.valor = data[:valor_pagamento].to_f
    
    obj.save!
  end
  
  def print_debug_info
    puts "------------------------------- DataImport Report --------------------------------"
    puts "CSV read options: #{@options}"
    puts "Arquivos:"
    @files.each do | file, records |
        puts "   --> #{file}: #{records} registros"
    end
    puts "Registros processados: #{@records_processed}"
    puts "Registros importados: #{@records_imported}"
    puts "------------------------------------- END ----------------------------------------"
  end
  
  def getFilename(mes, ano)
    data = ano.to_s + mes.to_s.rjust(2,'0')
    case @type
    when :diarias
      then @diretorio + data + getGOV_filename
    when :servidores
      then
        dias = Time.days_in_month(mes, ano)
        folder = "#{data}_Servidores/" 
        @diretorio + folder + data + dias.to_s + getGOV_filename
    end
  end
  
  def getGOV_filename
    case @type.to_s
      when "diarias" then "_Diarias.csv"
      when "servidores" then "_Cadastro.csv"
      else "unknow"
    end
  end
  
  def extract_data(data)
    case @type
    when :diarias
      then data.extract!(:cdigo_unidade_gestora, :nome_unidade_gestora, 
                         :cpf_favorecido, :nome_favorecido, :documento_pagamento, 
                         :data_pagamento, :valor_pagamento)
    when :servidores
      then
        data.extract!(:id_servidor_portal, :nome, :cpf, :matricula, :descricao_cargo, 
                      :classe_cargo, :padrao_cargo, :nivel_cargo, :sigla_funcao, :nivel_funcao,
                      :uorg_lotacao, :cod_org_lotacao, :cod_org_exercicio, :situacao_vinculo, :jornada_de_trabalho,
                      :data_ingresso_cargofuncao, :data_ingresso_orgao, :data_ingresso_servicopublico,
                      :data_diploma_ingresso_servicopublico, :diploma_ingresso_orgao)
    else {}
    end
  end
  
  def transform_data(data)
    case @type
      when :diarias
        then 
          data[:id_unidade] = data.delete :cdigo_unidade_gestora
          data[:nome_unidade] = data.delete :nome_unidade_gestora
          data[:cpf] = data.delete :cpf_favorecido
          data[:nome] = data.delete :nome_favorecido
          data[:num_doc] = data.delete :documento_pagamento
          data[:data] = data.delete :data_pagamento
          data[:valor] = data.delete :valor_pagamento
          
          data[:valor] = data[:valor].gsub! "," , "." # convertendo formato numerico. Ex: '1,50' para '1.50'
          return data   
      when :servidores
        then data
      else {}
    end # end case
  end
  
  # garante que sera usando um 'Range' ou 'Array' para meses e anos na importacao. 
  # Se vier um unico valor sera criado um range com apenas ele.
  def validate_range(value)
    classname = value.class.to_s
    case classname
      when "Range" 
        then value
      when "Array"
        then value
      else
        return (value..value)
    end
  end

  
end

