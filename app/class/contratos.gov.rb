# require 'nokogiri'
# require 'open-uri'
# 
# doc = Nokogiri::HTML(open('http://www3.transparencia.gov.br/TransparenciaPublica/jsp/contratos/contratoPorData.jsf?consulta2=2&CodigoOrgao=26410'))
# 
# puts doc.to_html


require 'rubygems'
require 'mechanize'

$contratos = Hash.new

url = 'http://www3.transparencia.gov.br/TransparenciaPublica/jsp/contratos/contratoPorData.jsf?consulta2=2&CodigoOrgao=26410'

agent = Mechanize.new
page = agent.get(url)

form = page.form_with(:id => 'form')
form.field_with(:name => "form:ano").options[0].select # TODOS os anos 
button = form.button_with(:value => "Pesquisar")

#envia o form simulando click no botao 'Pesquisar'
# recebemos a pagina com dados
result = agent.submit(form, button) 

# vamos mudar a quantidade de itens exibidos por pagina para 100
form = result.form_with(:id => 'form')
form.field_with(:id => 'form:dados:tamanhodapagina:linhaPorPagina').options[2].select
button = form.button_with(:value => "Pesquisar")

result = agent.submit(form, button)

ifnmg = { "INST.FED.DE EDUC.,CIENC.E TEC.DO NORTE DE MG" => 158121,
          "INST.FED.DO NORTE DE MG/CAMPUS MONTES CLAROS" => 158437,
          "INST.FED.DO NORTE DE MG/CAMPUS JANUARIA" => 158378,
          "INST.FED.DO NORTE DE MG/CAMPUS SALINAS" => 158377,
          "INST.FED.DO NORTE DE MG/CAMPUS ARINO" => 158438,
          "INST.FED.DO NORTE DE MG/CAMPUS ALMENARA" => 158439,
          "INST.FED.DO NORTE DE MG/CAMPUS PIRAPORA" => 158440,
          "INST.FED DO NORTE DE MG/CAMPUS ARACUAI" => 158441,
          "INST.FED.DO NORTE DE MG/CAMPUS ARINOS" => 158438
          
        }

table = result.xpath("//table[@id='form:dados:table']")

 table.css("tbody > tr").each do |row|
   
   num = row.css("td[1]").css("a").text.strip
   # puts num = row.css("td[1]").css("a").inspect
   
   link_detalhes = row.css("td[1]").css("a").to_s
   
   modalidade =  row.css("td[2]").text.strip
   situacao = row.css("td[3]").text.strip
   contratado = row.css("td[4]").text.strip
   unidade = row.css("td[5]").text.strip
   objeto = row.css("td[6]").text.strip
   
   $contratos[num.to_sym] = {:numero => num, :link_detalhes => link_detalhes, :modalidade => modalidade, :situacao => situacao, 
                             :contratado => contratado, :unidade => unidade, :objeto => objeto  }
   
   
   # puts "nº: " + num + ", Modalidade: " + modalidade + ", Situação: " + situacao +      ", Empresa: " +  contratado + ", Unidade: " + unidade + "\n\n"
 end
 
 # puts contratos.inspect
 
 $contratos.each do |k, v|
   puts k, v.inspect
   # puts v[:unidade].split("-")[1].strip
 end
 
 def getContratos
   return $contratos
 end
 
 
