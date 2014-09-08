#require 'csv'
#require 'open-uri'
#
#azteca_uri = 'http://localhost:8000/azteca-stocks.csv'
#terra_uri = 'http://localhost:8000/terra-stocks.csv'
#
#csv_uri = terra_uri
#
## requesting .csv resource from 'phony yahoo finance'
#azteca_csv_handler = open(csv_uri)
#
## encoding content as a string
#csv_string = azteca_csv_handler.read.encode!('UTF-8', 'iso-8859-1', invalid: :replace)
#
## parsing the .csv content
#stock_actions = CSV.parse(csv_string)
#
## saving .csv content to file
#CSV.open('D:/downloaded.csv', 'wb') do |csv|
#  for action in stock_actions do
#    csv << action
#  end
#end

# ------------------------------------------------------------------

#dir_path = 'D:'
#
#Dir.foreach(dir_path) do
#  |f|
#  path = "#{dir_path}/#{f}"
#
#  if File.directory?(path) then
#    puts(path)
#  end
#end

# ------------------------------------------------------------------

#def one_to_ten_iterator()
#  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].each{ |i|
#    yield i
#  }
#end
#
#one_to_ten_iterator { |item|
#  puts(item)
#}

# ------------------------------------------------------------------

#def returns_tuple()
#  return 1,2
#end
#
#result = returns_tuple()
#puts(result)

# ------------------------------------------------------------------

#require 'csv'
#load './crawler/file_system_crawler.rb'
#load './crawler/web_crawler.rb'
#
#uri_seeds = Array.new()
#
## ---------- FileSystemCrawler ----------
##uri_seeds << './datasources/'
##abstract_crawler = FileSystemCrawler.new(uri_seeds)
#
## ---------- WebCrawler ----------
#uri_seeds << 'http://localhost:8000/azteca-stocks.csv'
#uri_seeds << 'http://localhost:8000/terra-stocks.csv'
#abstract_crawler = WebCrawler.new(uri_seeds)
#
#
#abstract_crawler.crawl()
#handle_list = abstract_crawler.get_crawling_result()
#csv_content_list = Array.new()
#
#for h in handle_list do
#  csv_string = h.read.encode!('UTF-8', 'iso-8859-1', invalid: :replace)
#  csv_parsed = CSV.parse(csv_string)
#  csv_content_list << csv_parsed
#end

# ------------------------------------------------------------------

#load './stock_reader/csv_stock_reader.rb'
#
#uri_seeds = Array.new()
#
##uri_seeds << './datasources/'
##csv_st_rdr = CsvStockReader.new(uri_seeds, FILE_SYSTEM_SRC)
#
#
#uri_seeds << 'http://localhost:8000/azteca-stocks.csv'
#uri_seeds << 'http://localhost:8000/terra-stocks.csv'
#csv_st_rdr = CsvStockReader.new(uri_seeds, WEB_SRC)
#
## raeding stock streams from sources
#stock_streams = csv_st_rdr.read_stocks_from_sources()
#
#k = 0