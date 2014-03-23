class OrderBelongsToItem < ActiveRecord::Migration
  def change
    change_table :orders do |t|
        t.belongs_to :item
  	end
  end
end
