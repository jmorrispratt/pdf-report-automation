require 'pg'

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

      # configuring db connection
      configure_db_connection(db_name, db_user, db_pass)
    end

    def exec_sql_script(sql_script)
      # connection must be valid
      if @conn == nil then
        raise Exception('Invalid database connection. Please check connection parameters.')
      end

      # actually executing the script
      @conn.exec(sql_script)
    end

    def insert_yahoo_stock_data(enterprise_ticker)
      # empty --> this is like an abstract class method
    end

    def insert_infosel_stock_data(enterprise_ticker)
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
end

# ---------------------------------------------------------------------------------------------------