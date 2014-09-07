require 'open-uri'
load './crawler/abstract_crawler.rb'

# represents a filesystem crawler
class WebCrawler < AbstractCrawler
  # implementing only the abstract methods of AbstractCrawler

  # gets a stream from the uri (the content of a local file, of an url, etc.)
  def process_uri(uri)
    # trying to retrieve the web resource handle
    begin
      # getting a handle to the web resource
      resource_handler = open(uri)
    rescue Exception => e
      # the handle is nil
      resource_handler = nil
      puts(e)
    end

    # returning the handle to the uri's content
    return resource_handler
  end

  # extracts new uris that will be added to the uri_seeds
  def extract_uris(uri, uri_content)
    # in our case, no new uri can be extracted from a web resource
    return Array.new()
  end
end