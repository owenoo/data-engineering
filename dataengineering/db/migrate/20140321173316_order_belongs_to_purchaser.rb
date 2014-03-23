class OrderBelongsToPurchaser < ActiveRecord::Migration
  def change
    change_table :orders do |t|
        t.belongs_to :purchaser
  	end
  end
end
