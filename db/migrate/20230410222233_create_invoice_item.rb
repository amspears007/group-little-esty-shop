class CreateInvoiceItem < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_items do |t|
      t.references :item, foreign_key: true
      t.references :invoice, foreign_key: true
      t.integer :quantity
      t.integer :unit_price
      t.string :status
      t.string :timestamps
    end
  end
end
