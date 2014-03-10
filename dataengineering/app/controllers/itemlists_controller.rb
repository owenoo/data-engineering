require "csv"
class ItemlistsController < ApplicationController

def index
  @items = Itemlist.all
end

def new
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

            parsedLine = CSV.parse(row, { :col_sep => "\t" }).flatten!
            myHash = Hash[header.zip(parsedLine)]
            record = Itemlist.new(myHash)
            @total += record.itemPrice
            record.save
      end          
    rescue EOFError    
    end    
  end

  render action: "total", :total => @total

  #Total calculation will be visible on the index page
  #redirect_to action: "index"
end

def show  
    @item = Itemlist.find(params[:id])

    respond_to do |format|
    format.html # index.html.erb
    format.xml  { render :xml => @item }
    format.json  { render :json => @item.to_json }
    end
end

def edit
  @item = Itemlist.find(params[:id])
end

def update
  @item = Itemlist.find(params[:id])
 
  if @item.update(params[:post].permit(:title, :text))
    redirect_to @item
  else
    render 'edit'
  end
end

def destroy
  @item = Itemlist.find(params[:id])
  @item.destroy
 
  redirect_to itemlists_path
end
 

end