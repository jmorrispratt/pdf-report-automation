require './data_providers.rb'

# ---------------------------------------------------------------------------------------------------

class AbstractDbStockUpdater < Object
  protected
    # represents the uri seeds to get the data from
    @uri_seeds = nil

    # represents the data provider
    @data_provider = nil

    # represents the database name in which we will perform the operations
    @db_name = nil

    # represents the user used to connect to @db_name
    @db_user = nil

    # represents the password for @db_user
    @db_pass = nil

  public
    def initialize(db_name, db_user, db_pass, uri_seeds: [])
      # initializing the uri seeds
      @uri_seeds = uri_seeds

      # initializing the db related local variables
      @db_name = db_name
      @db_user = db_user
      @db_pass = db_pass
    end

    def set_uri_seeds(value)
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
    terra_id = 0
    maxcorp_id = 1

    for i in 0..clients_stock_list.length() do
      k = 0
    end

    k = 0

    #for clients_stock in clients_stock_list do
    #
    #end
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