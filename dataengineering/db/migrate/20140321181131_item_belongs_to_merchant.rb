class ItemBelongsToMerchant < ActiveRecord::Migration
  def change
    change_table :items do |t|
        t.belongs_to :merchant
  	end
  end
end
