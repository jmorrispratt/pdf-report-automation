require 'csv'
require './crawlers.rb'

# defining the types of stock sources
FILE_SYSTEM_SRC = 0
WEB_SRC = 1
TCP_IP_SRC = 2

# ---------------------------------------------------------------------------------------------------

# represents a generic stock reader
class AbstractStockReader < Object
  # protected members
  protected
  # represents the stock sources
  @stock_sources = nil

  # represents the whole data stream as an
  @data_streams = nil

  # an internal crawler for fetching resources
  @stock_crawler = nil

  # process a stock handle according to specific needs
  def process_stock_handle(stock_handle)
    # empty --> this is like an abstract class method
  end

  # public members
  public
  # initializer
  def initialize(stock_sources, sources_type)
    # checking correctness of the 'stock_sources' parameter
    if stock_sources == nil then
      return
    end

    # storing the stock sources value
    @stock_sources = Array.new()
    @stock_sources = stock_sources.clone()

    # initializing the data streams
    @data_streams = Array.new()

    # initializing crawler
    # case of file system stock sources
    if sources_type == FILE_SYSTEM_SRC
      @stock_crawler = FileSystemCrawler.new(@stock_sources)
    elsif sources_type == WEB_SRC
      @stock_crawler = WebCrawler.new(@stock_sources)
    else
      raise Exception.new('Unknown stock sources type.')
    end
  end

  # gets the stock streams from the sources
  def read_stocks_from_sources()
    # actually crawling and fetching the 'stock_sources'
    stock_handles = @stock_crawler.crawl()

    # clearing the previous data_streams
    @data_streams.clear()

    # for each handle obtained from the crawler
    for handle in stock_handles do
      # processing the stream according to particular needs
      processed_stream = process_stock_handle(handle)

      # adding the processed stream to the data streams
      @data_streams << processed_stream

      # closing file handle
      handle.close
    end

    # returning the resulting streams
    return @data_streams
  end

  def get_stock_sources()
    return @stock_sources
  end

  def get_data_streams()
    return @data_streams
  end
end

# ---------------------------------------------------------------------------------------------------

class CsvStockReader < AbstractStockReader
  # implementing only the abstract methods of AbstractStockReader

  # process a stock handle according to specific needs
  def process_stock_handle(stock_handle)
    # trying to process the 'stock_handle' in the case of .csv files
    begin
      # applying utf8 encoding
      csv_string = stock_handle.read.encode!('UTF-8', 'iso-8859-1', invalid: :replace)

      # parsing the raw .csv string
      csv_parsed = CSV.parse(csv_string)
    rescue Exception => e
      # the handle is nil
      csv_parsed = nil
      puts(e)
    end

    # returning the parsed .csv (by rows)
    return csv_parsed
  end
end

# ---------------------------------------------------------------------------------------------------

class PlainTextStockReader < AbstractStockReader
  # implementing only the abstract methods of AbstractStockReader

  # process a stock handle according to specific needs
  def process_stock_handle(stock_handle)
    # trying to process the 'stock_handle' in the case of plain text files files

    begin
      # applying utf8 encoding and replacing tabs with commas
      plain_string = stock_handle.read().encode('UTF-8', 'iso-8859-1', invalid: :replace).gsub(/\t/, ',')

      # parsing the raw .csv string
      plain_parsed = CSV.parse(plain_string)
    rescue Exception => e
      # the handle is nil
      plain_parsed = nil
      puts(e)
    end

    # returning the parsed plain text (by rows)
    return plain_parsed
  end
end

# ---------------------------------------------------------------------------------------------------