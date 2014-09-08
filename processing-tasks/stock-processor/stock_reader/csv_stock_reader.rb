require 'csv'
load './stock_reader/abstract_stock_reader.rb'

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