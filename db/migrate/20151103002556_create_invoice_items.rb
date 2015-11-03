class CreateInvoiceItems < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.references :item, index: true, foreign_key: true
      t.references :invoice, index: true, foreign_key: true
      t.numeric :quantity
      t.numeric :unit_price

      t.timestamps null: false
    end
  end
end
