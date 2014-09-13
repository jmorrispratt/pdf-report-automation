require 'pg'

NO_ERROR = 0
VALUE_NOT_FOUND = -1
DB_ERROR = -1

# ---------------------------------------------------------------------------------------------------

# represents an abstract StocksDbAdapter
class AbstractStocksDbAdapter < Object
  protected
    # represents a connection object to the database
    @conn = nil

    # database connection data
    @db_name = nil
    @db_user = nil
    @db_pass = nil

    # cache variables
    @ticker_id_chache = nil

    def configure_db_connection(db_name, db_user, db_pass)
      # empty --> this is like an abstract class method
    end

  # -----------------------------------------------------

  public
    def initialize(db_name, db_user, db_pass)
      # storing db connection settings
      @db_name = db_name
      @db_user = db_user
      @db_pass = db_pass

      @cache_ticker_id = Hash.new()

      # configuring db connection
      configure_db_connection(db_name, db_user, db_pass)
    end

    def exec_sql_script(sql_script)
      # connection must be valid
      if @conn == nil then
        raise Exception('Invalid database connection. Please check connection parameters.')
      end

      begin
        # actually executing the script
        result = @conn.exec(sql_script)
      rescue Exception => e
        # setting a nil result
        result = nil

        # printing error message
        puts(e)
      end

      # returning the result
      return result
    end

    def insert_yahoo_stock_data(stock_data, enterprise_ticker)
      # empty --> this is like an abstract class method
    end

    def insert_infosel_stock_data(stock_data, enterprise_ticker)
      # empty --> this is like an abstract class method
    end

    def get_owner_id_from_ticker(ticker)
      # empty --> this is like an abstract class method
    end

    def insert_enterprise_in_db(enterprise_ticker)
      # empty --> this is like an abstract class method
    end
end

# ---------------------------------------------------------------------------------------------------

# represents a pg_stocks_db_adapter
class PgStocksDbAdapter < AbstractStocksDbAdapter
  # implementing only the abstract methods of AbstractStocksDbAdapter

  def initialize(db_name, db_user, db_pass)
    # calling base constructor
    super(db_name, db_user, db_pass)
  end

  def configure_db_connection(db_name, db_user, db_pass)
    # trying to create a connection to db
    begin
      # connecting to db
      @conn = PG.connect(:dbname => db_name, :user => db_user, :password => db_pass)
    rescue Exception => e
      # setting db connection to nil
      @conn = nil

      # printing error message
      puts(e)
    end
  end

  def insert_yahoo_stock_data(stock_actions, enterprise_ticker)
      # the sql script to be executed in the 'database'
      sql_insertion_script = ''

      # building the sql script to execute
      ub = stock_actions.length() - 1
      for k in 0..ub do
        # getting 'stock_owner_id' value
        stock_owner_id = get_owner_id_from_ticker(enterprise_ticker)

        # getting the current stock action
        curr_stock_action = stock_actions[k]

        date = curr_stock_action[0]
        open = curr_stock_action[1]
        high = curr_stock_action[2]
        low = curr_stock_action[3]
        close = curr_stock_action[4]
        volume = curr_stock_action[5]
        adj_close = curr_stock_action[6]

        curr_insert_str = "INSERT INTO yahoo_stock_actions(date, open, high, low, close, volume, adj_close, stock_owner_id) VALUES('#{date}', #{open}, #{high}, #{low}, #{close}, #{volume}, #{adj_close}, #{stock_owner_id});"

        sql_insertion_script += "#{curr_insert_str}\n"
      end

    # inserting content in db
    exec_result = exec_sql_script(sql_insertion_script)

    # raising exception if there was a db_error
    if exec_result == nil then
      raise Exception('There was an error inserting in database. Please, check parameters.')
    end
  end

  def get_owner_id_from_ticker(ticker)
    # looking for 'stock_owner_id' in cache
    if @cache_ticker_id.has_key?(ticker) then
      return @cache_ticker_id[ticker]
    end

    # executing query in db
    column_name = 'enterprise_id'
    q_string = "SELECT #{column_name} FROM enterprises WHERE enterprise_ticker = '#{ticker}';"
    q_result = exec_sql_script(q_string)

    # if there was an error executing the query in the db
    if q_result == nil then
      raise Exception('There was an error in the db. Please, check your parameters.')
    end

    # if the supplied ticker does not exists add it to db
    if q_result.count() <= 0 then
      # inserting ticker in db
      insert_enterprise_in_db(ticker)

      # retrieving value from db
      q_result = exec_sql_script(q_string)
    end

    # saving 'stock_owner_id' in cache
    @cache_ticker_id[ticker] = q_result[0][column_name]

    # returning the associated id
    return q_result[0][column_name]
  end

  def insert_enterprise_in_db(enterprise_ticker)
    column_name = 'enterprise_tickersss'
    q_string = "INSERT INTO enterprises(#{column_name}) VALUES('#{enterprise_ticker}');"
    q_result = exec_sql_script(q_string)

    # if there was an error executing the query in the db
    if q_result == nil then
      raise Exception('There was an error in the db. Please, check your parameters.')
    end

    return NO_ERROR
  end
end

# ---------------------------------------------------------------------------------------------------