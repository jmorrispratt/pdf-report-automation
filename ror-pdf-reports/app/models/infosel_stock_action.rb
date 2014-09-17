# generated with the following rails command:
# infosel_stock_action buyer_id:integer seller_id:integer volume:integer price:decimal{5,2} total:decimal{10,2} time_stamp:timestamp stock_owner_id:integer
class InfoselStockAction < ActiveRecord::Base
  # enforcing a 'FK' at model level with the table 'mediators'
  belongs_to :to, :class_name => 'Mediator', :foreign_key => 'buyer_id'

  # enforcing a 'FK' at model level with the table 'mediators'
  belongs_to :to, :class_name => 'Mediator', :foreign_key => 'seller_id'

  # enforcing a 'FK' at model level with the table 'enterprises'
  belongs_to :to, :class_name => 'Enterprise', :foreign_key => 'stock_owner_id'
end
