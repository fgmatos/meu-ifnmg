class Servidor < ActiveRecord::Base
  
  # retorna os salarios
  def total_salarios(ano = nil, mes = nil)
    if ano.nil?
      return Remuneracao.where(:nome => self.nome).sum(:remuneracao_apos_deducoes)
    else
      if mes.nil?
        Remuneracao.where(:nome => self.nome, :ano => ano).sum(:remuneracao_apos_deducoes)
      else
        Remuneracao.where(:nome => self.nome, :ano => ano, :mes => mes).sum(:remuneracao_apos_deducoes)
      end
    end
  end
  
  def quant_salarios(ano = nil, mes = nil)
    if ano.nil?
      return Remuneracao.where(:nome => self.nome).count
    else
      if mes.nil?
        return Remuneracao.where(:nome => self.nome, :ano => ano).count
      else
        return Remuneracao.where(:nome => self.nome, :ano => ano, :mes => mes).count
      end
    end
  end
end
