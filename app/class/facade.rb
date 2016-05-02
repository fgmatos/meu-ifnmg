require "databridge.rb"

# This class implements the facade design pattern
class Facade
    # singleton design pattern implementation
    def self.getInstance
       @@instance ||= Facade.send :new
    end
    
    #fix bug 02.05.16 (has been removed from the module tree but is still active!)
    # its happened when server still runing after a long time and de Bridge Object is Destroyed from memory
    # => link: https://github.com/activeadmin/activeadmin/issues/2334
    
    # mapping bridge Model's Class to local vars (alias) for FACADE fast access
    def Diaria
       @diaria = ::TDiaria 
    end
    
    def Servidor
       @servidor ||= ::TServidor 
    end
    
    def Remuneracao
      @remuneracao ||= ::TRemuneracao
    end
    
    def Contato
       @contato ||= ::TContato
    end

    # private :new
    private_class_method :new    
end

FACADE = Facade.getInstance
