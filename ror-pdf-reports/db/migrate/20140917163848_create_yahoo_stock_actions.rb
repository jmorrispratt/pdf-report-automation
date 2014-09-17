# generated with the following rails command:
# rails generate model yahoo_stock_action date:date open:decimal{5,2} high:decimal{5,2} low:decimal{5,2} close:decimal{5,2} volume:integer adj_close:decimal{5,2} stock_owner_id:integer
class CreateYahooStockActions < ActiveRecord::Migration
  def change
    create_table(:yahoo_stock_actions, primary_key: 'action_id') do |t|
      t.date :date
      t.decimal :open, precision: 5, scale: 2
      t.decimal :high, precision: 5, scale: 2
      t.decimal :low, precision: 5, scale: 2
      t.decimal :close, precision: 5, scale: 2
      t.integer :volume
      t.decimal :adj_close, precision: 5, scale: 2
      t.integer :stock_owner_id

      t.timestamps
    end

    # -- ----------------------------
    # -- Foreign Key structure for table "public"."yahoo_stock_actions"
    # -- ----------------------------
    # ALTER TABLE "public"."yahoo_stock_actions" ADD FOREIGN KEY ("stock_owner_id") REFERENCES "public"."enterprises" ("enterprise_id") ON DELETE CASCADE ON UPDATE CASCADE;

    table_name = 'yahoo_stock_actions'
    fk_table_name = 'enterprises'
    fk_column_name = 'enterprise_id'
    column_name = 'stock_owner_id'

    stock_owner_id_fk = "ALTER TABLE #{table_name} ADD FOREIGN KEY (\"#{column_name}\") REFERENCES #{fk_table_name}(\"#{fk_column_name}\") ON DELETE CASCADE ON UPDATE CASCADE;"

    # enforcing foreign key constraints
    execute(stock_owner_id_fk)
  end
end
