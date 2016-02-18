class PagesController < ApplicationController
  
  def index   
    
  end
  
  def diarias
    @top10 = Diaria.select(:valor).where(:data => '01/2015'..'12/2015').group(:nome).order('sum_valor DESC').limit(10).sum(:valor)
  end
  
  def servidores
    @servidores = Servidor.all.order(:nome)
  end
  
end
