class PagesController < ApplicationController
  
  def index   
    
  end
  
  def diarias
    @top10 = Diaria.select(:valor).where(:data => '01/2015'..'12/2015').group(:nome).order('sum_valor DESC').limit(10).sum(:valor)
  end
  
  def servidores
    @servidores = Servidor.all.order(:nome)
  end
  
  def show_servidor
    if Servidor.exists?(params[:id])
       @servidor = Servidor.find(params[:id])
       render "pages/servidores/show"
    else
      flash[:danger] = "Atenção: servidor id(#{params[:id]}) não existe."
      redirect_to root_url
    end
  end
  
end
