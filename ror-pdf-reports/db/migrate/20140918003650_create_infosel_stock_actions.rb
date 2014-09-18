# generated with the following rails command:
# rails generate model infosel_stock_action buyer_id:integer seller_id:integer volume:integer price:decimal{5,2} total:decimal{10,2} time_stamp:timestamp enterprise_id:integer
class CreateInfoselStockActions < ActiveRecord::Migration
  def change
    create_table :infosel_stock_actions do |t|
      t.integer :buyer_id
      t.integer :seller_id
      t.integer :volume
      t.decimal :price, precision: 5, scale: 2
      t.decimal :total, precision: 10, scale: 2
      t.timestamp :time_stamp
      t.integer :enterprise_id

      t.timestamps
    end

    table_name = 'infosel_stock_actions'
    fk_table_name = 'mediators'
    fk_column_name = 'id'

    column_name = 'buyer_id'
    buyer_id_fk = "ALTER TABLE #{table_name} ADD FOREIGN KEY (\"#{column_name}\") REFERENCES #{fk_table_name}(\"#{fk_column_name}\")
                    ON DELETE CASCADE
                    ON UPDATE CASCADE;"

    column_name = 'seller_id'
    seller_id_fk = "ALTER TABLE #{table_name} ADD FOREIGN KEY (\"#{column_name}\") REFERENCES #{fk_table_name}(\"#{fk_column_name}\")
                      ON DELETE CASCADE
                      ON UPDATE CASCADE;"

    column_name = 'enterprise_id'
    fk_table_name = 'enterprises'
    fk_column_name = 'id'
    stock_owner_id_fk = "ALTER TABLE #{table_name} ADD FOREIGN KEY (\"#{column_name}\") REFERENCES #{fk_table_name}(\"#{fk_column_name}\")
                          ON DELETE CASCADE
                          ON UPDATE CASCADE;"

    # enforcing foreign key constraints
    execute(buyer_id_fk)
    execute(seller_id_fk)
    execute(stock_owner_id_fk)
  end
end
