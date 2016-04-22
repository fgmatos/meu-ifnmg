require "databridge.rb"

# This class implements the facade design pattern
class Facade
    # singleton design pattern implementation
    def self.getInstance
       @@instance ||= Facade.send :new
    end
    
    # mapping bridge Model's Class to local vars (alias) for FACADE fast access
    def Diaria
       @diaria = TDiaria 
    end
    
    def Servidor
       @servidor = TServidor 
    end
    
    def Remuneracao
      @remuneracao = TRemuneracao
    end

    # private :new
    private_class_method :new    
end

FACADE = Facade.getInstance
