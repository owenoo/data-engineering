class Purchaser < ActiveRecord::Base
    has_many :orders

  # Attempts to get a purchaser by name, otherwise creates it in the database and returns it
    def self.get_set(name)
        p = Purchaser.where(name: name)
        if(p.empty?)            
            new_purchaser = Purchaser.new(:name => name) 
            new_purchaser.save
            p = Purchaser.where(name: name)
        end
        return p     
    end
end
