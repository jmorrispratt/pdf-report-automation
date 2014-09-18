# generated with the following rails command:
# rails generate model yahoo_stock_action date:date open:decimal{5,2} high:decimal{5,2} low:decimal{5,2} close:decimal{5,2} volume:integer adj_close:decimal{5,2} enterprise_id:integer
class YahooStockAction < ActiveRecord::Base
end
