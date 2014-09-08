require './stock_readers.rb'

TITLE = :title
SOCIAL_REASON = :social_reason
TICKER = :ticker
SERIES = :series
START_DATE = :start_date
END_DATE = :end_date
ACTIONS_META = :actions_meta
ACTIONS = :actions

TITLE_INDEX = 0
SOCIAL_INDEX = 2
TICKER_INDEX = 3
SERIES_INDEX = 4
START_DATE_INDEX = 5
END_DATE_INDEX = 6
FACTS_META_INDEX = 10
FACTS_INDEX = 11

# ---------------------------------------------------------------------------------------------------

# represents an abstract data provider
class AbstractDataProvider < Object
  # protected members
  protected
  # represents the stock reader (CsvStockReader, JsonStockReader, etc.)
  @stock_reader = nil

  # represents the information of all stocks
  @stocks = nil

  # public members
  public
  def get_stocks()
    return @stocks
  end

  # initializer (constructor)
  def initialize(stock_sources)
    ## initializing data structures
    #@facts = Array.new()

    # initializing data structures
    @stocks = Array.new()

    # getting information from data stream
    get_info_from_streams()
  end

  # private members
  private
  # gets information from 'data_streams'
  def get_info_from_streams()
    # setting the data stream to a local variable
    data_streams = @stock_reader.read_stocks_from_sources()

    # processing all the data streams
    for stream in data_streams do
      # processing the curent 'data_stream'
      stock_info = process_data_stream(stream)

      # storing the processed 'stock_info'
      @stocks << stock_info
    end

    # returning all the gathered information
    return @stocks
  end

  def process_data_stream(data_stream)
    # creating the structure that will hold the 'stock_info'
    stock_info = Hash.new()

    # getting the stock data 'title'
    stock_info[:title] = data_stream[TITLE_INDEX][0] # the first column

    # getting the stock data 'social reason'
    social_reason_data = data_stream[SOCIAL_INDEX][0]
    stock_info[:social_reason] = social_reason_data.split(':')[1].strip() # the right part of the first column

    # getting the stock data 'ticker'
    ticker_data = data_stream[TICKER_INDEX][0]
    stock_info[:ticker] = ticker_data.split(':')[1].strip() # the right part of the first column

    # getting the stock data 'series'
    series_data = data_stream[SERIES_INDEX][0]
    stock_info[:series] = series_data.split(':')[1].strip() # the right part of the first column

    # getting the stock data 'start date'
    start_date_data = data_stream[START_DATE_INDEX][0]
    start_splitted = start_date_data.split(':')[1].split('/') # splitting by ':' and '/'
    month = start_splitted[0].to_i()
    day = start_splitted[1].to_i()
    year = start_splitted[2].to_i()
    stock_info[:start_date] = Date.new(year, month, day)

    # getting the stock data 'end date'
    end_date_data =  data_stream[END_DATE_INDEX][0]
    end_splitted = end_date_data.split(':')[1].split('/') # splitting by ':' and '/'
    month = end_splitted[0].to_i()
    day = end_splitted[1].to_i()
    year = end_splitted[2].to_i()
    stock_info[:end_date] = Date.new(year, month, day)

    # getting the 'facts metadata'
    stock_info[:actions_meta] = data_stream[FACTS_META_INDEX]

    # getting 'facts'
    ub = data_stream.count() - 1

    actions = Array.new()
    # getting actual stock actions
    for i in FACTS_INDEX..ub
      # storing raw facts information
      actions << data_stream[i]
    end
    stock_info[:actions] = actions

    # returning the gathered 'stock_info'
    return stock_info
  end
end

# ---------------------------------------------------------------------------------------------------

class InfoselDataProvider < AbstractDataProvider
  # implementing only the abstract methods of AbstractCrawler

  # overriding initializer (constructor)
  def initialize(stock_sources)
    # setting the 'stock_reader' to a 'web_stock_reader'
    @stock_reader = CsvStockReader.new(stock_sources, FILE_SYSTEM_SRC)

    # calling base constructor
    super(stock_sources)
    # getting information from data stream
  end
end

# ---------------------------------------------------------------------------------------------------

class YahooDataProvider < AbstractDataProvider
  # implementing only the abstract methods of AbstractCrawler

  # overriding initializer (constructor)
  def initialize(stock_sources)
    # setting the 'stock_reader' to a 'web_stock_reader'
    @stock_reader = CsvStockReader.new(stock_sources, WEB_SRC)

    # calling base constructor
    super(stock_sources)
    # getting information from data stream
  end
end

# ---------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------