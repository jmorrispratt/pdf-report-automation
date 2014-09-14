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

      # cache variables
      @cache_ticker_id = Hash.new()
      @cache_mediator_id = Hash.new()

      # configuring db connection
      configure_db_connection(db_name, db_user, db_pass)
    end

    def exec_sql_script(sql_script)
      # connection must be valid
      if @conn == nil then
        raise Exception.new('Invalid database connection. Please check connection parameters.')
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

    def insert_yahoo_stock_data(stock_actions, enterprise_ticker)
      # empty --> this is like an abstract class method
    end

    def get_owner_id_from_ticker(ticker)
      # empty --> this is like an abstract class method
    end

    def insert_enterprise_in_db(enterprise_ticker)
      # empty --> this is like an abstract class method
    end

    def insert_infosel_stock_data(stock_actions, enterprise_ticker)
      # empty --> this is like an abstract class method
    end

    def get_mediator_id_from_name(mediator_name)
      # empty --> this is like an abstract class method
    end

    def insert_mediator_in_db(mediator_name)
      # empty --> this is like an abstract class method
    end

    def get_operative_details(enterprise_ticker, start_date, end_date)
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
    commit_rate = 100
    for k in 0..ub do
      # getting the current stock action
      curr_stock_action = stock_actions[k]

      # getting row values
      date = curr_stock_action[0]
      open = curr_stock_action[1]
      high = curr_stock_action[2]
      low = curr_stock_action[3]
      close = curr_stock_action[4]
      volume = curr_stock_action[5]
      adj_close = curr_stock_action[6]
      stock_owner_id = get_owner_id_from_ticker(enterprise_ticker) # getting 'stock_owner_id' value

      # building the insert instruction
      curr_insert_str = "INSERT INTO yahoo_stock_actions(date, open, high, low, close, volume, adj_close, stock_owner_id) VALUES('#{date}', #{open}, #{high}, #{low}, #{close}, #{volume}, #{adj_close}, #{stock_owner_id});"

      # adding the insert instruction to the script
      sql_insertion_script += "#{curr_insert_str}\n"

      # inserting each 'commit_rate + 1' operations
      if (k + 1) % commit_rate == 0 or k == ub then
        # inserting content in db
        exec_result = exec_sql_script(sql_insertion_script)

        # raising exception if there was a db_error
        if exec_result == nil then
          raise Exception.new('There was an error inserting in database. Please, check parameters.')
        end

        # reseting the sql insertion script
        sql_insertion_script = ''
      end
    end
  end

  def get_owner_id_from_ticker(ticker)
    # looking for 'stock_owner_id' in cache
    if @cache_ticker_id.has_key?(ticker) then
      return @cache_ticker_id[ticker]
    end

    # executing query in db
    column_name = 'enterprise_id'
    q_string = "SELECT #{column_name} FROM enterprises WHERE enterprise_ticker='#{ticker}';"
    q_result = exec_sql_script(q_string)

    # if there was an error executing the query in the db
    if q_result == nil then
      raise Exception.new('There was an error in the db. Please, check your parameters.')
    end

    # if the supplied 'ticker' does not exists add it to db
    if q_result.count() <= 0 then
      # inserting ticker in db
      insert_enterprise_in_db(ticker)

      # retrieving value from db
      q_result = exec_sql_script(q_string)
    end

    # saving 'stock_owner_id' in cache
    @cache_ticker_id[ticker] = q_result[0][column_name]

    # returning the associated id
    return @cache_ticker_id[ticker]
  end

  def insert_enterprise_in_db(enterprise_ticker)
    column_list = 'enterprise_ticker, enterprise_name'
    q_string = "INSERT INTO enterprises(#{column_list}) VALUES('#{enterprise_ticker}', '#{enterprise_ticker}');"
    q_result = exec_sql_script(q_string)

    # if there was an error executing the query in the db
    if q_result == nil then
      raise Exception.new('There was an error in the db. Please, check your parameters.')
    end

    return NO_ERROR
  end

  def insert_infosel_stock_data(stock_actions, enterprise_ticker)
    # the sql script to be executed in the 'database'
    sql_insertion_script = ''

    # building the sql script to execute
    ub = stock_actions.length() - 1
    commit_rate = 100
    for k in 0..ub do
      # getting the current stock action
      curr_stock_action = stock_actions[k]

      # getting row values
      buyer_id = get_mediator_id_from_name(curr_stock_action[0])  # getting the 'buyer_id'
      seller_id = get_mediator_id_from_name(curr_stock_action[1]) # getting the 'seller_id'
      volume = curr_stock_action[2]
      price = curr_stock_action[3]
      total = curr_stock_action[4]
      time_stamp = curr_stock_action[5]
      stock_owner_id = get_owner_id_from_ticker(enterprise_ticker) # getting the 'stock_owner_id'


      # building the insert instruction
      curr_insert_str = "INSERT INTO infosel_stock_actions(buyer_id, seller_id, volume, price, total, time_stamp, stock_owner_id) VALUES(#{buyer_id}, #{seller_id}, #{volume}, #{price}, #{total}, '#{time_stamp}', #{stock_owner_id});"

      # adding the insert instruction to the script
      sql_insertion_script += "#{curr_insert_str}\n"

      # inserting each 'commit_rate + 1' operations
      if (k + 1) % commit_rate == 0 or k == ub then
        # inserting content in db
        exec_result = exec_sql_script(sql_insertion_script)

        # raising exception if there was a db_error
        if exec_result == nil then
          raise Exception.new('There was an error inserting in database. Please, check parameters.')
        end

        # reseting the sql insertion script
        sql_insertion_script = ''
      end
    end
  end

  def get_mediator_id_from_name(mediator_name)
    # looking for 'mediator_id' in cache
    if @cache_mediator_id.has_key?(mediator_name) then
      return @cache_mediator_id[mediator_name]
    end

    # executing query in db
    column_name = 'mediator_id'
    q_string = "SELECT #{column_name} FROM mediators WHERE mediator_name='#{mediator_name}';"
    q_result = exec_sql_script(q_string)

    # if there was an error executing the query in the db
    if q_result == nil then
      raise Exception.new('There was an error in the db. Please, check your parameters.')
    end

    # if the supplied 'mediator_name' does not exists add it to db
    if q_result.count() <= 0 then
      # inserting ticker in db
      insert_mediator_in_db(mediator_name)

      # retrieving value from db
      q_result = exec_sql_script(q_string)
    end

    # saving 'stock_owner_id' in cache
    @cache_mediator_id[mediator_name] = q_result[0][column_name]

    # returning the associated id
    return @cache_mediator_id[mediator_name]
  end

  def insert_mediator_in_db(mediator_name)
    column_name = 'mediator_name'
    q_string = "INSERT INTO mediators(#{column_name}) VALUES('#{mediator_name}');"
    q_result = exec_sql_script(q_string)

    # if there was an error executing the query in the db
    if q_result == nil then
      raise Exception.new('There was an error in the db. Please, check your parameters.')
    end

    return NO_ERROR
  end

  def get_operative_details(enterprise_ticker, start_date, end_date)
    start_date_str = "#{start_date.year}-#{start_date.month}-#{start_date.day} #{start_date.hour}:#{start_date.minute}:#{start_date.second}"
    end_date_str = "#{end_date.year}-#{end_date.month}-#{end_date.day} #{end_date.hour}:#{end_date.minute}:#{end_date.second}"
    limit = 4

    # helper queries
    q_helpers =
"
WITH

stocks_from_enterprise AS
(
	SELECT
		time_stamp,
		buyer_id,
		seller_id,
		volume,
		total
	FROM
		infosel_stock_actions JOIN enterprises ON (stock_owner_id = enterprise_id)
	WHERE
		enterprise_ticker = '#{enterprise_ticker}'
),

-- -------------------------------------------------------------

enterprise_stocks_in_time_range AS
(
	SELECT
		*
	FROM
		stocks_from_enterprise
	WHERE
		'#{start_date_str}' <= time_stamp AND time_stamp <= '#{end_date_str}'
),

-- -------------------------------------------------------------

buyers_ranking AS
(
	SELECT
		mediator_name,
		round(SUM(total) * 100.0 / (SELECT SUM(total) FROM enterprise_stocks_in_time_range), 2) as contribution
	FROM
		enterprise_stocks_in_time_range JOIN mediators ON (buyer_id = mediator_id)
	GROUP BY
		mediator_name
	ORDER BY
		contribution DESC
	LIMIT #{limit}				-- getting top 'limit' only
),

-- -------------------------------------------------------------

sellers_ranking AS
(
	SELECT
		mediator_name,
		round(SUM(total) * 100.0 / (SELECT SUM(total) FROM enterprise_stocks_in_time_range), 2) as contribution
	FROM
		enterprise_stocks_in_time_range JOIN mediators ON (seller_id = mediator_id)
	GROUP BY
		mediator_name
	ORDER BY
		contribution DESC
	LIMIT #{limit}				-- getting top 'limit' only
)
"

    # getting buyer's operative details
    q_buyers = 'SELECT * FROM buyers_ranking'
    q_string = "#{q_helpers}\n#{q_buyers}"
    buyers_details = exec_sql_script(q_string)

    # if there was an error executing the query in the db
    if buyers_details == nil then
      raise Exception.new('There was an error in the db. Please, check your parameters.')
    end

    # processing the query answer
    buyers_operative_details = Array.new()
    cum_percent = 0.0

    buyers_details.each do |row|
      buyers_operative_details << row
      cum_percent += row['contribution'].to_f()
    end

    # adding a row associated with other mediators
    others_percent = 100.0 - cum_percent
    buyers_operative_details << {'mediator_name' => 'OTROS', 'contribution' => others_percent.round(2)}

    # getting seller's operative details
    q_sellers = 'SELECT * FROM sellers_ranking'
    q_string = "#{q_helpers}\n#{q_sellers}"
    sellers_details = exec_sql_script(q_string)

    # if there was an error executing the query in the db
    if sellers_details == nil then
      raise Exception.new('There was an error in the db. Please, check your parameters.')
    end

    # processing the query answer
    sellers_operative_details = Array.new()
    cum_percent = 0.0
    sellers_details.each do |row|
      sellers_operative_details << row
      cum_percent += row['contribution'].to_f()
    end
    # adding a row associated with other mediators
    others_percent = 100.0 - cum_percent
    sellers_operative_details << {'mediator_name' => 'OTROS', 'contribution' => others_percent.round(2)}


    # returning the result
    return Array.new([buyers_operative_details, sellers_operative_details])
  end
end

# ---------------------------------------------------------------------------------------------------