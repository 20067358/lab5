class Product < ActiveRecord::Base

	has_many :inventories

    validates_presence_of :title,  :description, :price, :image_url, :message => "Falta ingresar, ya sea, el title, description, price, image_url"
    validates_numericality_of :price, :greater_than => 0.01, :message => "Debe Ingresar un numero mayor que 0.01"	
    validates_uniqueness_of :title, :message => "Este titulo ya existe, ingrese uno diferente."	
    validates_format_of :image_url, :with => %r{\.(gif|jpg|png)$}i, :message => "Ingrese un URL Valido"  
    validates_numericality_of :projection, :greather_than => 0, :message => "El campo projection debe ser mayor que cero (0)"
	
	protected
	def after_create
		crear_inventario = Inventory.new :product_id => self.id, :previous_balance => 0, :new_balance => self.amount, :future_balance => self.amount + self.projection
		crear_inventario.save
	end
	
	def after_update
		p = Inventory.find_last_by_product_id(self.id)
		crear_inventario = Inventory.new :product_id => self.id, :previous_balance => p.new_balance, :new_balance => self.amount, :future_balance => self.amount + self.projection
		crear_inventario.save
	end

	def before_destroy
		Inventory.delete_all(:product_id => self.id) 
	end

end
