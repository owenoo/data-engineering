class Order < ActiveRecord::Base
    belongs_to :purchaser
    belongs_to :merchant
    belongs_to :item

    def self.calc_sum   

        query_string = "SELECT SUM(i.price) as 'total' 
                        FROM orders o
                        JOIN items i ON o.item_id = i.id"

        @total_from_items_sold = JSON.parse(Order.find_by_sql(query_string).to_json)             

        return @total_from_items_sold.first["total"]
    end

end
