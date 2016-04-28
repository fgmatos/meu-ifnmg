

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
  # => reitoria, salinas, januaria, montes-claros, arinos, almenara, pirapora, aracuai
  UGS =  ["158121", "158377", "158378", "158437", "158438", "158439", "158440", "158441"]
  
  # if TRUE show report  
  DEBUG = TRUE
  
  @@instances = 0
    
  # constructor 
  def initialize(type, year_range, month_range, options = nil)
    
    puts "started: #{Time.now.strftime("%d/%m/%Y - %H:%M:%S")} " if DEBUG
    
    #conf
    @conf = Hash.new
    
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
    # =>  suportados :diarias, :servidores e :remuneracoes
    @type = type.to_sym
    
    # diretorio base para a importacao de dados
    # => Ex.: app/data/servidores
    @diretorio = getDIR
    
    @year_range = validate_range(year_range)
    
    if month_range == :all
      @months_range = 1..12  
    else
      @months_range = validate_range(month_range)
    end
    
    # default options
    @options = {headers: true, encoding:'windows-1250', col_sep: "\t", header_converters: :symbol}
    
    # if user seted personal options include with default options
    if (!options.nil?)
      @options.merge!(options)          
    end
    
    @@instances += 1
  end
  
  def execute
    # percorre os anos a realizar a importacao
    @year_range.each do |year|
      # os meses tambem
      for month in @months_range
        
        # gera o nome do arquivo a ser importado
        @filename = getFilename(month, year)
        # contabiliza as importacoes
        @files[ @filename.to_sym ] = 0 
        # se estive com DEBUG ativo, imprime acompanhamento da execucao
        if (DEBUG)
          print "\n#{Time.now.strftime("%H:%M:%S")} - #{@type} #{year}/#{month.to_s.rjust(2,'0')}: "
        end
        # vamos processar os dados no arquivo
        process(@filename)
        
        print " lines-> #{@conf[:line]+2}, imported-> #{@records_each_file}" if DEBUG
      end
    end
    # imprime relatorio apos importacao, se o DEBUG estiver ativo
    print_debug_info if DEBUG
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
      # this block is equivalent to try..except 
      begin
        @conf[:file] = file
        temp = File.read(file, encoding:"ISO-8859-1")
        
        # remove 'aspas' do arquivo
        @file = strip(temp)
        
        # converte o arquivo para CSV
        @csvfile = parse(@file)
        
        # CSV.foreach(file, @options) do |row|
        @csvfile.each_with_index do |row, i|
          # convert o registro para um hash
          data = row.to_hash
          @conf[:line] = i
          # testa se o registro tiver dados relacionados ao IFNMG
          if belongsIFNMG(data)
            if !@test_mode
              import(data)         
            end
            @records_each_file += 1
            @records_imported +=  1     
          end
        end # end foreach
        @records_processed += @conf[:line]+2
      rescue => ex
        puts "\nErro : #{file}, record: #{@conf[:line]} - Exception: #{ex.class} -> #{ex.message}"
        puts " => #{data.inspect}"
      end
      @files[ @filename.to_sym ] = @records_each_file 
      
    else # file not exits
      puts "Error on importing: #{file}!. File no found."
    end # if file.exist?
    
  end
  
  def parse(file)
    # convert opened file to CSV format
    return CSV.parse(file, @options)
  end
  
  def strip(file)
    # removendo (") aspas duplas para evitar conflitos na leitura
    return file.gsub('"',"'")
  end
  
  def belongsIFNMG(data)
    # testa se esta linha do CSV tem um registro do IFNMG
    case @type
      when :diarias then UGS.include? data[:cdigo_unidade_gestora]
      when :servidores then (UORG.to_s == data[:cod_org_lotacao]) || (UORG.to_s == data[:cod_org_exercicio])
      when :remuneracoes then FACADE.Servidor.exists?( {:cpf => data[:cpf], :nome => data[:nome]} )
      else "unknow filter"
    end
  end
  
  def exists(data)
    # testa se os dados desta linha já foram importados 
    case @type
      when :diarias then 
        false
      when :servidores then
        # procuramos se ja existe servidor cadastrado 
        saved = FACADE.Servidor.where(cpf: data[:cpf])
        # puts "#{saved.inspect}"
        # se o ActiveRelation[0].nil? - não ouve resultado
        if !saved[0].nil?
          # se a consulta retornou dados vamos percorer cada um para verificar se o CPF e NOME sao iguais
          # precisamos que os DOIS valores sejam identicos, pois apenas o CPF pode ser repetido,
          # por que temos somente parte dele
          saved.each do |s|
            if s.cpf == data[:cpf] && s.nome == data[:nome]
              return true
            end
          end # end each
          #se passou por todos os registros e nenhum é igual, entao retornamos FALSO, para inserir um NOVO REGISTRO
          return false
        else 
          # consulta retornou nil, entao o registro nao existe
            return false
        end
      when :remuneracoes then 
        false
      else # caso o typo nao seja valido
        "Tipo invalido"
    end
  end
  
  
  def import(data)
    
    begin
      # Seleciona o Model a ser utilizado para salvar os dados
      @model = case @type
        when :diarias then
          @model = FACADE.Diaria
        when :servidores then
          @model = FACADE.Servidor
        when :remuneracoes then
          @model = FACADE.Remuneracao
      end
      
      # criamos uma cópia dos dados para logs (DEBUG)
      received_data = data.clone
      
      # retira do hash apenas os campos existentes no Model
      fields = extract_data(data)
      
      # converte as chaves de acesso no hash para o mesmo nomes utilizado no model
      params = transform_data(fields)
      
      # se nao existe o registro, vamos criar um
      if !exists(params) 
        # criamos um novo objeto passando os dados como parametros
        obj = @model.new( params )
        
        # definimos informacoes de rastreio : Arqiovo.csv#linha
        obj.traking_info = "#{@conf[:file].split("/").last}##{@conf[:line]+2}"
            
        obj.save!  
      else
        # se existe, vamos atualizar
        saved = FACADE.Servidor.where(cpf: params[:cpf])
        saved.each do |s|
          if s.cpf == params[:cpf] && s.nome == params[:nome]
            # atualizamos o rastreio, assim sabemos TODOS os arquivos e linhas que alteraram este registro 
            params[:traking_info] = s.traking_info + ",#{@conf[:file].split("/").last}##{@conf[:line]+2}"
            s.update( params )
            break
          end
        end # end each
      end 
      
    rescue => ex
      puts "\nErro on import! , model #{@model} - Exception: #{ex.class} -> #{ex.message}"
      puts "\n data   => #{received_data.inspect}"
      puts "\n fields => #{fields.inspect}"
      puts "\n params => #{params.inspect}"
    end
  end
  
  def print_debug_info
    puts "\n------------------------------- DataImport Report --------------------------------"
    puts "CSV read options: #{@options}"
    puts "Finished: #{Time.now.strftime("%d/%m/%Y - %H:%M:%S")}"
    puts "Arquivos:"
    @files.each do | file, records |
        puts "   --> #{file.to_s.split("/").last}: #{records} registros"
    end
    puts "Registros processados: #{@records_processed}"
    puts "Registros importados.: #{@records_imported}"
    puts "------------------------------------- END ----------------------------------------"
  end
  
  def getFilename(mes, ano)
    data = ano.to_s + mes.to_s.rjust(2,'0')
    case @type
      when :diarias then
        @diretorio + data + getGOV_filename
      when :servidores then
        dias = Time.days_in_month(mes, ano)
        folder = "#{data}_Servidores/" 
        @diretorio + folder + data + dias.to_s + getGOV_filename
      when :remuneracoes then
        dias = Time.days_in_month(mes, ano)
        folder = "#{data}_Servidores/" 
        @diretorio + folder + data + dias.to_s + getGOV_filename
    end
  end
  
  def getGOV_filename
    case @type
      when :diarias then "_Diarias.csv"
      when :servidores then "_Cadastro.csv"
      when :remuneracoes then "_Remuneracao.csv"
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
    when :remuneracoes 
      then
        data.extract!(:ano, :mes, :id_servidor_portal, :cpf, :nome, :remunerao_bsica_bruta_r,
                      :abateteto_r, :gratificao_natalina_r, :abateteto_da_gratificao_natalina_r,
                      :frias_r, :outras_remuneraes_eventuais_r, :irrf_r, :pssrpgs_r, :penso_militar_r,
                      :fundo_de_sade_r, :demais_dedues_r, :remunerao_aps_dedues_obrigatrias_r,
                      :verbas_indenizatrias_registradas_em_sistemas_de_pessoal__civil_r,
                      :verbas_indenizatrias_registradas_em_sistemas_de_pessoal__militar_r,
                      :total_de_verbas_indenizatrias_r, :total_de_honorrios_jetons, :total_de_jetons)
    else 
      { :null => "data invalid"}
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
      when :remuneracoes
        then 
          data[:ano]  = data.delete :ano
          data[:mes] = data.delete :mes
          data[:id_servidor_portal] = data.delete :id_servidor_portal
          data[:cpf] = data.delete :cpf
          data[:nome] = data.delete :nome
          
          data[:remuneracao_basica_bruta_rs] = data.delete :remunerao_bsica_bruta_r
          data[:abate_teto_rs] = data.delete :abateteto_r
          data[:gratificacao_natalina_rs] = data.delete :gratificao_natalina_r
          data[:abate_teto_gratificacao_natalina] = data.delete :abateteto_da_gratificao_natalina_r
          data[:ferias] = data.delete :frias_r
          data[:outras_remuneracoes_eventuais] = data.delete :outras_remuneraes_eventuais_r
          data[:irrf] = data.delete :irrf_r
          data[:pss_rpgs] = data.delete :pssrpgs_r
          data[:pensao_militar] = data.delete :penso_militar_r
          data[:fundo_de_saude] = data.delete :fundo_de_sade_r
          data[:demais_deducoes] = data.delete :demais_dedues_r
          data[:remuneracao_apos_deducoes] = data.delete :remunerao_aps_dedues_obrigatrias_r
          data[:verbas_indenizatorias_civil] = data.delete :verbas_indenizatrias_registradas_em_sistemas_de_pessoal__civil_r
          data[:verbas_indenizatorias_militar] = data.delete :verbas_indenizatrias_registradas_em_sistemas_de_pessoal__militar_r
          data[:total_verbas_indenizatorias] = data.delete :total_de_verbas_indenizatrias_r
          
          data[:total_honorarios] ||= data.delete :total_de_jetons
          data[:total_honorarios] ||= data.delete :total_de_honorrios_jetons
          
          # corrigindo formato numerico
          # data.each do |key, value|
            # data[key] = value.gsub! "," , "."
          # end 
          data[:remuneracao_basica_bruta_rs] = data[:remuneracao_basica_bruta_rs].gsub! "," , "."
          data[:abate_teto_rs] = data[:abate_teto_rs].gsub! "," , "."
          data[:gratificacao_natalina_rs] = data[:gratificacao_natalina_rs].gsub! "," , "."
          data[:abate_teto_gratificacao_natalina] = data[:abate_teto_gratificacao_natalina].gsub! "," , "."
          data[:ferias] = data[:ferias].gsub! "," , "."
          data[:outras_remuneracoes_eventuais] = data[:outras_remuneracoes_eventuais].gsub! "," , "."
          data[:irrf] = data[:irrf].gsub! "," , "."
          data[:pss_rpgs] = data[:pss_rpgs].gsub! "," , "."
          data[:pensao_militar] = data[:pensao_militar].gsub! "," , "."
          data[:fundo_de_saude] = data[:fundo_de_saude].gsub! "," , "."
          data[:demais_deducoes] = data[:demais_deducoes].gsub! "," , "."
          data[:remuneracao_apos_deducoes] = data[:remuneracao_apos_deducoes].gsub! "," , "."
          data[:verbas_indenizatorias_civil] = data[:verbas_indenizatorias_civil].gsub! "," , "."
          data[:verbas_indenizatorias_militar] = data[:verbas_indenizatorias_militar].gsub! "," , "."
          data[:total_verbas_indenizatorias] =  data[:total_verbas_indenizatorias].gsub! "," , "."
          data[:total_honorarios] = data[:total_honorarios].gsub! "," , "."
        
          return data
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
  
  def getDIR
    case @type 
      when :remuneracoes
        then Rails.root.join("app","data","servidores").to_s + "/"
      else
        Rails.root.join("app","data",@type.to_s).to_s + "/"      
    end
  end  

  
end

