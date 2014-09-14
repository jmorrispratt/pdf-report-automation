require './data_providers.rb'
require './db_adapters.rb'

# ---------------------------------------------------------------------------------------------------

class AbstractDbStockUpdater < Object
  protected
    # represents the uri seeds to get the data from
    @uri_seeds = nil

    # represents the data provider
    @data_provider = nil

    # represents a stocks_db_adapter
    @db_adapter = nil

  public
    def initialize(db_name, db_user, db_pass, uri_seeds: [])
      # initializing the uri seeds
      @uri_seeds = uri_seeds

      # initializing the db adapter
      @db_adapter = PgStocksDbAdapter.new(db_name, db_user, db_pass)
    end

    def set_uri_seeds(value)
      # the uri_seeds 'value' must be valid
      if value == nil then
        return
      end

      # setting the uri seeds
      @uri_seeds = value
    end

    def update_db()
      # empty --> this is like an abstract class method
    end
end

# ---------------------------------------------------------------------------------------------------

class InfoselDbStockUpdater < AbstractDbStockUpdater
  # implementing only the abstract methods of AbstractDbStockUpdater

  # static uri seeds generator method
  def InfoselDbStockUpdater.get_uri_seeds()
    # creating the uri seeds result
    uri_seeds = Array.new()

    # adding the uri seeds
    uri_seeds << './datasources/'

    # returning the results
    return uri_seeds
  end

  # -----------------------------------------------------

  def initialize(db_name, db_user, db_pass, uri_seeds: [])
    # calling base constructor
    super(db_name, db_user, db_pass, uri_seeds: uri_seeds)
    # getting information from data stream

    # initializing the data provider
    @data_provider = InfoselDataProvider.new(@uri_seeds)
  end

  def update_db()
    # getting all the retrieved stocks
    clients_stock_list = @data_provider.get_stocks()

    ub = clients_stock_list.length() - 1
    for i in 0..ub do
      # getting the current stock actions information
      ticker = clients_stock_list[i][:ticker]
      stock_actions = clients_stock_list[i][:actions]

      # adding 'current owner' yahoo finance data to database
      @db_adapter.insert_infosel_stock_data(stock_actions, ticker)
    end
  end
end

# ---------------------------------------------------------------------------------------------------

class YahooFinanceDbStockUpdater < AbstractDbStockUpdater
  # implementing only the abstract methods of AbstractDbStockUpdater

  # static uri seeds generator method
  def YahooFinanceDbStockUpdater.get_uri_seeds()
    # creating the uri seeds result
    uri_seeds = Array.new()

    # adding the uri seeds
    uri_seeds << 'http://localhost:8000/terra-stocks.csv'
    uri_seeds << 'http://localhost:8000/maxcom-stocks.csv'

    # returning the results
    return uri_seeds
  end

  # -----------------------------------------------------

  def initialize(db_name, db_user, db_pass, uri_seeds: [])
    # calling base constructor
    super(db_name, db_user, db_pass, uri_seeds: uri_seeds)
    # getting information from data stream

    # initializing the data provider
    @data_provider = YahooDataProvider.new(@uri_seeds) # empty seeds for now
  end

  def update_db()
    # getting all the retrieved stocks
    clients_stock_list = @data_provider.get_stocks()

    # the tickers of enterprises in the same order data comes, but this is just for now
    tickers = Array.new()

    # adding the stock owner id's to the list
    tickers << 'TERRA'   # terra's ticker
    tickers << 'MAXCOM'  # maxcom's ticker

    ub = clients_stock_list.length() - 1
    for i in 0..ub do
      # getting the current stock actions information
      stock_actions = clients_stock_list[i][:actions] # the metadata is located at 0 index, but it's not important now

      # adding 'current owner' yahoo finance data to database
      @db_adapter.insert_yahoo_stock_data(stock_actions, tickers[i])
    end
  end
end

# ---------------------------------------------------------------------------------------------------



# basically executes a sql script in certain database
def exec_sql_script_in_db(db_name, db_user, db_pass, sql_script)
  # connecting to the given database
  conn = PG.connect(
      :dbname => db_name,
      :user => db_user,
      :password => db_pass)

  # actually executing the script
  conn.exec(sql_script)
end

# ---------------------------------------------------------------------------------------------------