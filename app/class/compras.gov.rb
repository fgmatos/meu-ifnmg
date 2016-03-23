# Testes da API de compras do Governo Federal
# => http://compras.dados.gov.br/docs/contratos/v1/contratos.html

# descrição da API
# http://compras.dados.gov.br/{modulo}/v1/{metodo}.{formato}?{parametro1=valor1}&{parametro2=valor2}&{parametroN=valorN}


require 'rubygems'
require 'mechanize'

url = "http://compras.dados.gov.br/contratos/v1/contratos.json?uasg=158121&data_assinatura_min=2015-01-01&data_assinatura_max=2015-12-31"

agent = Mechanize.new
page = agent.get(url)

puts page.inspect