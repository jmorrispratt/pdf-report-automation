# generated with the following rails command:
# rails generate model mediator mediator_name:string{40}
class Mediator < ActiveRecord::Base
  # specifying FK relation with InfoselStockAction at model level
  has_many :infosel_stock_actions, :foreign_key => 'buyer_id', :class_name => 'InfoselStockAction'
  has_many :infosel_stock_actions, :foreign_key => 'seller_id', :class_name => 'InfoselStockAction'
end
