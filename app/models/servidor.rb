class Servidor < ActiveRecord::Base
  
  # retorna os salarios
  def total_salarios(ano = nil, mes = nil)
    total = 0.0
    if ano.nil?
      @remuneracao = ::Remuneracao.where(:nome => self.nome)
      @remuneracao.each do |data|
        total += ( data.remuneracao_basica_bruta_rs.to_f + data.verbas_indenizatorias_civil.to_f + data.gratificacao_natalina_rs.to_f + data.ferias.to_f + data.outras_remuneracoes_eventuais.to_f )
      end
      return total
      #return ::Remuneracao.where(:nome => self.nome).sum(:remuneracao_basica_bruta_rs)
    else
      if mes.nil?
        @remuneracao = ::Remuneracao.where(:nome => self.nome, :ano => ano)
        @remuneracao.each do |data|
          total += ( data.remuneracao_basica_bruta_rs.to_f + data.verbas_indenizatorias_civil.to_f + data.gratificacao_natalina_rs.to_f + data.ferias.to_f + data.outras_remuneracoes_eventuais.to_f )
        end
        return total
        #::Remuneracao.where(:nome => self.nome, :ano => ano).sum(:remuneracao_apos_deducoes)
      else
          @remuneracao = ::Remuneracao.where(:nome => self.nome, :ano => ano, :mes => mes)
          @remuneracao.each do |data|
            total += ( data.remuneracao_basica_bruta_rs.to_f + data.verbas_indenizatorias_civil.to_f + data.gratificacao_natalina_rs.to_f + data.ferias.to_f + data.outras_remuneracoes_eventuais.to_f )
          end
          return total
          #::Remuneracao.where(:nome => self.nome, :ano => ano, :mes => mes).sum(:remuneracao_apos_deducoes)
      end
    end
  end
  
  def quant_salarios(ano = nil, mes = nil)
    if ano.nil?
      return ::Remuneracao.where(:nome => self.nome).count
    else
      if mes.nil?
        return ::Remuneracao.where(:nome => self.nome, :ano => ano).count
      else
        return ::Remuneracao.where(:nome => self.nome, :ano => ano, :mes => mes).count
      end
    end
  end
end
