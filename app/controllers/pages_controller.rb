class PagesController < ApplicationController
  
  before_action :load_unidade, only: [:unidade]
  
  def index   
    # "pages/index.html.haml"
  end
  
  # GET "/unidades" - Retorna todas unidades do IFNMG
  def unidades
    # "pages/unidades.html.haml"
  end
  
  # GET "/unidades/:name" - Retorna informacoes sobre uma Unidade do IFNMG
  def unidade
    @diarias = FACADE.Diaria.where("nome_unidade like ?", "%#{@unidade}%")
    @servidores = FACADE.Servidor.where("uorg_lotacao like ?", "%#{@unidade}%")
    render "pages/unidades/show", locals: { unidade: @unidade }
  end
  
  def diarias
  
    @top10 = FACADE.Diaria.select(:valor).
                            where(:data => '2015-01-01'..'2015-12-31').
                            group(:nome).order('sum_valor DESC').
                            limit(10).sum(:valor)
    
    @quantidade_diarias_unidade = FACADE.Diaria.group(:nome_unidade).order('count_all DESC').count
    
    @valor_diarias_servidor_2015 = FACADE.Diaria.select(:valor).
                                  where(:data => '2015-01-01'..'2015-12-31').
                                  group(:nome).order('sum_valor DESC').limit(10).sum(:valor)
                                  
    @valor_diarias_unidade_2015 = FACADE.Diaria.where(:data => '2015-01-01'..'2015-12-31').
                                      group(:nome_unidade).sum(:valor)
    
    @diarias = FACADE.Diaria.all.order("data DESC")
    
    respond_to do |format|
       format.html { render "pages/diarias" }
       format.json { render json: JSON.pretty_generate( JSON.parse @diarias.to_json ) }
       format.csv  { render text: @diarias.to_csv }
       format.xml  { render xml: @diarias }
    end
    
    # render "pages/diarias"
  end
  
  def servidores
    @servidores = FACADE.Servidor.all.order(:nome)
    
    respond_to do |format|
       format.html { render "pages/servidores" }
       format.json { render json: JSON.pretty_generate( JSON.parse @servidores.to_json ) }
       format.csv  { render text: @servidores.to_csv }
       format.xml  { render xml: @servidores }
    end
    
    
  end
  
  def show_servidor
    if FACADE.Servidor.exists?(params[:id])
       @servidor = FACADE.Servidor.find(params[:id])
       @minhas_diarias = FACADE.Diaria.where("NOME = ?", @servidor.nome)
       render "pages/servidores/show"
    else
      # flash msg's use :danger, :alert or :info       
      flash[:danger] = "Atenção: servidor id(#{params[:id]}) não existe."
      redirect_to root_url
    end
  end
  
  private
  
  def load_unidade
    @unidade = params[:name]
  end
  
end
