class AddTrakingInfoToAll < ActiveRecord::Migration
  def up
    # Diarias
    add_column :diaria, :traking_info, :string
    # Diaria.all.each do |d|
      # d.update_attributes!(:traking_info => "unknown")
    # end
    
    # Servidores
    add_column :servidors, :traking_info, :string
    # Servidor.all.each do |s|
      # s.update_attributes!(:traking_info => "unknown")
    # end
      
    # Remuneracoes
    add_column :remuneracoes, :traking_info, :string
    # Remuneracao.all.each do |r|
      # r.update_attributes!(:traking_info => "unknown")
    # end
  end
  
  def down
    remove_column :diaria, :traking_info
    remove_column :servidors, :traking_info
    remove_column :remuneracoes, :traking_info
  end
end
