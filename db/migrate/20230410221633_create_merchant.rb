class CreateMerchant < ActiveRecord::Migration[5.2]
  def change
    create_table :merchants do |t|
      t.string :name
      t.string :timestamps
    end
  end
end
