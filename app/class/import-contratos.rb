#!/usr/bin/env ruby
# require 'rails'
# require File.expand_path('../../config/environment/development.rb')

require 'transparencia.gov.br.rb'
require 'contrato.rb'

link_base = "http://www3.transparencia.gov.br/TransparenciaPublica/jsp/contratos/"

contratos ||= APIGov.new(:contratos)
@contratos ||= contratos.getContratos

@contratos.each do | num, valores |
  c = Contrato.new
  
  c.numero = valores[:numero]
  c.ano = valores[:numero].split("/").last
  c.modalidade = valores[:modalidade]
  c.situacao = valores[:situacao]
  c.contratado = valores[:contratado]
  c.contratado_cnpj = valores[:contratado].split(" - ").first
  
  # c.contratado_nome
  
  c.unidade = valores[:unidade]
  c.unidade_id = valores[:unidade].split(" - ").last
  c.unidade_nome = valores[:unidade].split(" - ").first
  
  c.objeto = valores[:objeto]
  
  c.link = (l.to_s + valores[:link_detalhes].to_s.split('"').second.gsub("amp;", "") )
  c.ref = num+1 
  
  c.save!
  
end