class CreateItemlists < ActiveRecord::Migration
  def change
    create_table :itemlists do |t|
      t.string :purchaserName
      t.string :itemDesc
      t.float :itemPrice
      t.integer :purchaseCount
      t.string :merchAddress
      t.string :merchName

      t.timestamps
    end
  end
end
