class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :from, null: false
      t.integer :to, null: false
      t.integer :amount, null: false
      t.timestamps
    end
  end
end
