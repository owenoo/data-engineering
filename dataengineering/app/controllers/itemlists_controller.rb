require "csv"
class ItemlistsController < ApplicationController

    def index
        query_string = "SELECT o.id as 'id',
                                p.name as 'purchaser name', 
                                i.description as 'item description', 
                                i.price as 'item price', 
                                o.purchase_count as 'purchase count',
                                m.name as 'merchant name', 
                                m.address as 'merchant address' 
                        FROM orders o 
                        INNER JOIN merchants m on m.id = o.merchant_id 
                        INNER JOIN items i on i.id = o.item_id 
                        INNER JOIN purchasers p ON p.id = o.purchaser_id";                     

        @order_hash = JSON.parse(Order.find_by_sql(query_string).to_json)  
    end

    def new
        @order = Order.new
        @item = Itemlist.new
    end

    def create 
      
        #Download user file to server   
        @fileinfo = params[:itemlist][:fileinfo]
        Itemlist.filesave(@fileinfo)    

        #Parse downloaded file
        @filepath = 'public/data/'  
        junkHeader = []
        @total = 0
        File.open(@filepath + @fileinfo.original_filename) do |fi|
            begin 
                #consume the first line in the file so we can process at the right index      
                1.times.each{ junkHeader += CSV.parse(fi.readline, { :col_sep => "\t" }) }   

                #map file header names to ActiveRecord fields      
                header = []     
                header[0] = 'purchaserName'
                header[1] = 'itemDesc'  
                header[2] = 'itemPrice'
                header[3] = 'purchaseCount'
                header[4] = 'merchAddress'
                header[5] = 'merchName'


                # since files can be very large with company datasets, we read 
                # the file one line at a time after it has been uploaded to the server    
                fi.each_line do |row|

                    parsed_line = CSV.parse(row, { :col_sep => "\t" }).flatten!
                    myHash = Hash[header.zip(parsed_line)]
                    record = Itemlist.new(myHash)

                    #A given line looks like
                    #purchaser name item description  item price  purchase count  merchant address  merchant name
                    #Amy Pond       $30 of awesome for    $10           10.0      5 456 Unreal Rd     Tom's Awesome Shop    
                    
                    # A MORE OBJECT-ORIENTED APPROACH
                    # The next few model methods attempt to lookup the purchaser/merchant/item 
                    # If it doesn't exist in our database, we create it.  After we have
                    # all three points of data, we create a new order record in our database.            
                    p = Purchaser.get_set(myHash['purchaserName']) 
                    m = Merchant.get_set(myHash['merchName'], myHash['merchAddress'])
                    i = Item.get_set(myHash['itemDesc'], myHash['itemPrice']) 

                    unless p.empty? || m.empty? || i.empty?
                        o = Order.new(:purchase_count => myHash['purchaseCount'], 
                                  :purchaser_id => p.first.id, 
                                  :merchant_id => m.first.id, 
                                  :item_id => i.first.id); 
                        o.save   
                    end              

                    @total += record.itemPrice
                    record.save
                end          
            rescue EOFError    
            end    
        end

        render action: "total", :total => @total
        #Total calculation will be visible on the index page  
    end

    def show  
        # Instead of using the ItemList's show method, I now use the orders_controller's show method.
    end

    def edit
        @order = Order.find(params[:id])
    end

    def update
        @order = Order.find(params[:id])

        if @order.update(params[:post].permit(:title, :text))
            redirect_to @order
        else
            render 'edit'
        end
    end

    def destroy
        @order = Order.find(params[:id])
        @order.destroy

        redirect_to itemlists_path
    end
end