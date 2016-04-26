class ContatosController < ApplicationController
  
  def create
    # @contact = Contact.new(contact_params)
    
    @contact = FACADE.Contato.new(contatos_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to root_path, notice: 'Obrigado por enviar sua menssagem!' }
        format.json { render :show, status: :created, location: root_path }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # Never trust parameers from the scary internet, only allow the white list through.
  def contatos_params
    params.require(:contact).permit(:nome, :email, :mensagem, :created_at)
  end
  
  
  

  
end
