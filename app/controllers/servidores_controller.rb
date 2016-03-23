class ServidoresController < ApplicationController
  
  def all
    @servidores = FACADE.Servidor.all.order(:nome)
    # render "pages/servidores"
  end 
  
end
