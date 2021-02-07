require 'rubygems'
require 'mechanize'

class APIGov
  
  URL_BASE = "http://www3.transparencia.gov.br/TransparenciaPublica/jsp/"
  
  def initialize(modulo)
    
    @modulo = modulo
    @operacoes = [  "contratoPorData", 
                    "contratoPorModalidade",
                    "contratoPorSituacao", 
                    "contratoPorContratado",
                    "contratoPorUnidadeGestora", 
                    "contratoBuscaAvancada"        ]
    
    @id_orgao = 26410 
    
    @url = URL_BASE + @modulo.to_s + "/contratoPorData.jsf?consulta2=2&CodigoOrgao=" + @id_orgao.to_s
    
    @dados = Hash.new
    @dados[@modulo] = Hash.new
    
    @agent = Mechanize.new
    @page = @agent.get(@url)
    
    execute
  end
  
  def all(ano)
    @dados[@modulo]
  end
  
  # private
  
  def execute
      update_page
      if hasPagination
        puts "Existem paginas"
        set_records
        
        paginas = getTotalPages
        # puts paginas = getTotalPages
        
        getPageData
        for i in 2..paginas.to_i 
          next_page(i)
          getPageData
        end
        
      end
  end
  
  #load initial data from module/operation in @page
  def update_page
    form = @page.form_with(:id => 'form')
    form.field_with(:name => "form:ano").options[0].select
    button = form.button_with(:value => "Pesquisar")
    
    @page = @agent.submit(form, button) 
  end
  
  def set_records
    form = @page.form_with(:id => 'form')
    form.field_with(:id => 'form:dados:tamanhodapagina:linhaPorPagina').options[2].select #100
    button = form.button_with(:value => "Pesquisar")
    
    @page = @agent.submit(form, button) 
  end
  
  def next_page(page_number)
    puts "load page: " + page_number.to_s
    form = @page.form_with(:id => 'form')
    form.field_with(:id => "form:pagina").value = page_number
    button = form.button_with(:value => "Pesquisar")
    
    @page = @agent.submit(form, button) 
  end
  
  def getPageData
      table = @page.xpath("//table[@id='form:dados:table']")

      table.css("tbody > tr").each do |row|
       
         num = row.css("td[1]").css("a").text.strip
         # puts num = row.css("td[1]").css("a").inspect
         
         link_detalhes = row.css("td[1]").css("a").to_s
         
         modalidade =  row.css("td[2]").text.strip
         situacao = row.css("td[3]").text.strip
         contratado = row.css("td[4]").text.strip
         unidade = row.css("td[5]").text.strip
         objeto = row.css("td[6]").text.strip
         
         @dados[@modulo][@dados[@modulo].length] = {
                              :numero => num, 
                              :link_detalhes => link_detalhes,
                              :modalidade => modalidade,
                              :situacao => situacao,
                              :contratado => contratado,
                              :unidade => unidade,
                              :objeto => objeto
                }
         
         # @dados[@modulo].store :numero, num 
         # @dados[@modulo].store :link_detalhes, link_detalhes
         # @dados[@modulo].store :modalidade, modalidade
         # @dados[@modulo].store :situacao, situacao
         # @dados[@modulo].store :contratado, contratado
         # @dados[@modulo].store :unidade, unidade
         # @dados[@modulo].store :objeto, objeto  
         
     end # end each row
  end

  def hasPagination
    if  @page.at_xpath("//span[@id='form:dados:migalha']//span//a")
      true
    else
      false
    end
  end
  
  def getTotalPages
    last_link = 0
    pagination = @page.xpath("//span[@id='form:dados:migalha']")
    pagination.css("span > a").each do | link |
      puts link.text
      last_link = link.text
    end
    return last_link
  end
  
  def inspect
    @page.form.inspect
  end
  
  def getContratos
   return @dados[@modulo]
 end
  

end

# contratos = APIGov.new(:contratos)
# 
# contratos.getContratos
# puts contratos.hasPagination
# puts contratos.getTotalPages
# puts contratos.inspect
