class Merchant < ActiveRecord::Base
    has_many :items
    has_many :orders

    # Attempts to get a merchant by name, otherwise creates it in the database and returns it
    def self.get_set(name, address)
        m = Merchant.where(name: name)
        if(m.empty?)
            new_merchant = Merchant.new(:name => name, :address => address)
            new_merchant.save
            m = Merchant.where(name: name)
        end
        return m        
    end

end
