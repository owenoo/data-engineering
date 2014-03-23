class Item < ActiveRecord::Base
	belongs_to :merchant
	has_many :orders

	# Attempts to get an item by description, otherwise creates it in the database and returns it
	def self.get_set(desc, price)
        i = Item.where(description: desc)
        if(i.empty?)
          new_item = Item.new(:description => desc, :price => price)
          new_item.save  
          i = Item.where(description: desc)
        end  
        return i     
	end
end
