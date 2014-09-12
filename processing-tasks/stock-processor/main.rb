require './db_updaters.rb'

DB_NAME = 'stock_data'
DB_USER = 'postgres'
DB_PASS = '123'

# ---------------------------------------------------------------------------------------------------

infosel_start = Time.now().to_f()

# generating the uri seeds to get data from
infosel_uri_seeds = InfoselDbStockUpdater.get_uri_seeds()

# creating an infosel db updater
infosel_updater = InfoselDbStockUpdater.new(DB_NAME, DB_USER, DB_PASS, uri_seeds: infosel_uri_seeds)

# updating the db
infosel_result = infosel_updater.update_db()

infosel_time = Time.now().to_f() - infosel_start
puts("Infosel Update Time:\t#{(infosel_time * 1000.0).to_i()} ms")

# ---------------------------------------------------------------------------------------------------

yahoo_start = Time.now().to_f()

# generating the uri seeds to get data from
yahoo_uri_seeds = YahooFinanceDbStockUpdater.get_uri_seeds()

# creating a yahoo db updater
yahoo_updater = YahooFinanceDbStockUpdater.new(DB_NAME, DB_USER, DB_PASS, uri_seeds: yahoo_uri_seeds)

# updating the db
yahoo_result = yahoo_updater.update_db()

yahoo_time = Time.now().to_f() - yahoo_start
puts("Yahoo Update Time:\t#{(yahoo_time * 1000.0).to_i()} ms")

# ---------------------------------------------------------------------------------------------------