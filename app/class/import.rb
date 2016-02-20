

require "csv"

# Class DataImport
# => @type: Tipo de dado que será importado.
# => @name:  nome final do arquivi csv baixado para importacao - Baseado no @type
# => @diretorio: pasta padrão onde os arquivos CSV foram baixados + pasta do dado a ser importado
#   

class DataImport 
  
  UORG = 26410
  UGS =  ["158121", "158377", "158378", "158437", "158438", "158439", "158440", "158441"]
  
  # if TRUE show report  
  DEBUG = TRUE
  
  @@count = 0
    
  
  def initialize(type, year_range, month_range, options = nil)
    
    @records_processed = 0
    @records_imported = 0
    
    @records_each_file = 0
    @files = Hash.new
    
    @type = type.to_sym
    @name =  getGOV_file_str
    
    @diretorio = Rails.root.join("app","data",@type.to_s).to_s + "/"
    
    @year_range = year_range
    
    if month_range == :all
      @months_range = 1..12  
    else
      @months_range = month_range
    end
    
    if (options.nil?)
      @options = {headers: true, encoding:'windows-1250', col_sep: "\t", header_converters: :symbol}
    else
      @options = options          
    end
    
    @@count += 1
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
    "DataImport: " + @@count.to_s
  end
    
  private
  
  def process(file)
    @records_each_file = 0
    
    if (DEBUG)
      puts "importing: " + file.to_s
    end
    
    CSV.foreach(file, @options) do |row|
      data = row.to_hash
      @records_processed +=  1
      if doFilter(data)
        import(data)   
        #puts "nº " + @records_imported.to_s + ": " + data[:nome_favorecido].to_s     
      end
    end
    @files[ @filename.to_sym ] = @records_each_file 
  end
  
  def doFilter(data)
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
    
    @records_each_file += 1
    @records_imported +=  1
  end
  
  def print_debug_info
    puts "------------------------------- DataImport Report --------------------------------"
    puts "Arquivos:"
    @files.each do | file, records |
        puts "   --> "+ file.to_s + ": " + records.to_s + " registros"
    end
    puts "Registros processados: " + @records_processed.to_s
    puts "Registros importados: " + @records_imported.to_s
    puts "------------------------------------- END ----------------------------------------"
  end
  
  def getFilename(mes, ano)
    @diretorio + ano.to_s + mes.to_s.rjust(2,'0') + @name
  end
  
  def getGOV_file_str
    case @type.to_s
      when "diarias" then "_Diarias.csv"
      when "servidores" then "31_Cadastro.csv"
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
                      :cod_org_lotacao, :cod_org_exercicio, :situacao_vinculo, :jornada_de_trabalho,
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
          return data   
      when :servidores
        then data
      else {}
    end # end case
  end
  
  
  
end

