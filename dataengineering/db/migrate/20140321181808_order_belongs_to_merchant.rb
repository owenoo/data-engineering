class OrderBelongsToMerchant < ActiveRecord::Migration
  def change
    change_table :orders do |t|
        t.belongs_to :merchant
  	end
  end
end
