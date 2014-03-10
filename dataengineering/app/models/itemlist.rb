class Itemlist < ActiveRecord::Base	

	def self.calcSum
		allItemlists = Itemlist.all

		sum = 0
		allItemlists.each do |i|
			sum += i.itemPrice
		end	
		
		return sum
	end

	def self.filesave (upload)  	  	
		name =  upload.original_filename
	    directory = "public/data"
	    # create the file path
	    path = File.join(directory, name)
	    # write the file
	    File.open(path, "wb") { |f| f.write(upload.read) }
	end

end
