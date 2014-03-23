class OrdersController < ApplicationController

def show       
    query_string = "SELECT p.name as 'purchaser name', 
    			           i.description as 'item description', 
    			           i.price as 'item price', 
    			           o.purchase_count as 'purchase count',
     					   m.name as 'merchant name', 
     					   m.address as 'merchant address' 
     				FROM orders o 
     				INNER JOIN merchants m on m.id = o.merchant_id 
     				INNER JOIN items i on i.id = o.item_id 
     				INNER JOIN purchasers p ON p.id = o.purchaser_id 
     				WHERE o.id = " + params[:id];

    @order_hash = JSON.parse(Order.find_by_sql(query_string).to_json)

    respond_to do |format|
    format.html # index.html.erb
    format.xml  { render :xml => @order_hash }
    format.json  { render :json => @order_hash.to_json }
    end
end

end
