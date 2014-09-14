require './db_updaters.rb'
require './db_adapters.rb'

DB_NAME = 'stock_data'
DB_USER = 'postgres'
DB_PASS = '123'

# ---------------------------------------------------------------------------------------------------

#infosel_start = Time.now().to_f()
#
## generating the uri seeds to get data from
#infosel_uri_seeds = InfoselDbStockUpdater.get_uri_seeds()
#
## creating an infosel db updater
#infosel_updater = InfoselDbStockUpdater.new(DB_NAME, DB_USER, DB_PASS, uri_seeds: infosel_uri_seeds)
#
## updating the db
#infosel_result = infosel_updater.update_db()
#
#infosel_time = Time.now().to_f() - infosel_start
#puts("Infosel Update Time:\t#{(infosel_time * 1000.0).to_i()} ms")

# ---------------------------------------------------------------------------------------------------

#yahoo_start = Time.now().to_f()
#
## generating the uri seeds to get data from
#yahoo_uri_seeds = YahooFinanceDbStockUpdater.get_uri_seeds()
#
## creating a yahoo db updater
#yahoo_updater = YahooFinanceDbStockUpdater.new(DB_NAME, DB_USER, DB_PASS, uri_seeds: yahoo_uri_seeds)
#
## updating the db
#yahoo_result = yahoo_updater.update_db()
#
#yahoo_time = Time.now().to_f() - yahoo_start
#puts("Yahoo Update Time:\t#{(yahoo_time * 1000.0).to_i()} ms")

# ---------------------------------------------------------------------------------------------------

details_start = Time.now().to_f()

pg_adapter = PgStocksDbAdapter.new(DB_NAME, DB_USER, DB_PASS)

enterprise_ticker = 'AZTECA'
date_start = DateTime.strptime('2014-08-11 08:00:00 AM', '%Y-%m-%d %I:%M:%S %p')
date_end = DateTime.strptime('2014-08-15 3:00:00 PM', '%Y-%m-%d %I:%M:%S %p')

details_result = pg_adapter.get_operative_details(enterprise_ticker, date_start, date_end)

details_time = Time.now().to_f() - details_start
puts("Operative Details Query Time:\t#{(details_time * 1000.0).to_i()} ms")
puts('--------------------------------------')

# getting buyers information
puts('Buyers operative details:')

buyers_info = details_result[0]
buyers_info.each do |row|
  puts("#{row['contribution']}%\t\t#{row['mediator_name']}")
end

puts()
# getting sellers information
puts('Sellers operative details:')

sellers_info = details_result[1]
sellers_info.each do |row|
  puts("#{row['contribution']}%\t\t#{row['mediator_name']}")
end

# ---------------------------------------------------------------------------------------------------