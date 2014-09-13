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
    return @data_provider.get_stocks()
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
    uri_seeds << 'http://localhost:8000/maxcomp-stocks.csv'

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

    # esto debe ir en un array
    tickers = Array.new()

    # defining the 'stock_owner_id' in this way to be more understandable
    terra_ticker =  'TERRA'
    maxcom_ticker = 'MAXCOM'
    azteca_ticker = 'AZTECA'

    # adding the stock owner id's to the list
    tickers << terra_ticker   # terra's ticker
    tickers << maxcom_ticker  # maxcom's ticker
    tickers << azteca_ticker  # azteca's ticker

    for i in 0..clients_stock_list.length() do
      # getting the current stock actions information
      stock_actions = clients_stock_list[i][1] # the metadata is located at 0 index, but it's not important now

      @db_adapter.insert_yahoo_stock_data()

      # the sql script to be executed in the 'database'
      sql_insertion_script = ''

      # building the sql script to execute
      for k in 0..stock_actions.length() do
        # checking if 'stock_owner' exists in db
        stock_owner_id = @db_adapter.get_stock_owner_id()
        # adding 'stock_owner' to database
        if stock_owner_id <= 0 then

        end
      end

      # executing the sql script in db (inserting data in db)
      @db_adapter.exec_sql_script(sql_insertion_script)
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