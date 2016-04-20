class Diaria < ActiveRecord::Base
  
  def self.TotalDiarias(ano = nil)
    if ano.nil?
      self.select(:valor).order('sum_valor DESC').sum(:valor)
    else
      self.select(:valor).where("data BETWEEN ? AND ? ", ano.to_s + "-01-01", ano.to_s + "-12-31").order('sum_valor DESC').sum(:valor)
    end
  end
  
end
