# generated with the following rails command:
# rails generate model enterprise enterprise_ticker:string{50} enterprise_name:string{100}
class Enterprise < ActiveRecord::Base
  # has_many :to, :class_name => 'InfoselStockAction', :foreign_key => 'stock_owner_id'

  # has_many :to, :class_name => 'YahooStockAction', :foreign_key => 'stock_owner_id'

  # has_many :yah, :foreign_key => 'user_id', :class_name => "Task"
  has_many :yahoo_stock_actions, :foreign_key => 'stock_owner_id', :class_name => 'YahooStockAction'

  has_many :infosel_stock_actions, :foreign_key => 'stock_owner_id', :class_name => 'InfoselStockAction'
end
