# generated with the following rails command:
# rails generate model enterprise enterprise_ticker:string{50} enterprise_name:string{100}
class Enterprise < ActiveRecord::Base
  # specifying FK relation with InfoselStockAction at model level
  has_many :infosel_stock_actions, :foreign_key => 'enterprise_id', :class_name => 'InfoselStockAction'

  # specifying FK relation with YahooStockAction at model level
  has_many :yahoo_stock_actions, :foreign_key => 'enterprise_id', :class_name => 'YahooStockAction'
end
