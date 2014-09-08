# represents a generic crawler
class AbstractCrawler < Object
  # protected members
  protected
    # -------------------- variables --------------------

    # represents the seeds
    @uri_seeds = nil

    # stores the information related with a crawling in progress
    @is_crawling = false

    # represents the result
    @crawling_result = nil

    # -------------------- methods --------------------

    # gets a stream from the uri (the content of a local file, of an url, etc.)
    def process_uri(uri)
      # empty --> this is like an abstract class method
    end

    # extracts new uris that will be added to the uri_seeds
    def extract_uris(uri, uri_content)
      # empty --> this is like an abstract class method
    end

  # public members
  public
    # initializer
    def initialize(uri_seeds, start_crawling=false)
      # setting @uri_seeds value
      @uri_seeds = uri_seeds

      # initializing the @crawling_result variable
      @crawling_result = Array.new()

      # starting the crawling process if required
      if start_crawling
        # crawling
        crawl()
      end
    end

    # crawls the uri_seeds
    def crawl()
      # another crawling instance is already running
      if @is_crawling then
        return
      end

      # there are no seeds to crawl
      if @uri_seeds.length() == 0 then
        return
      end

      # setting flag of crawling in progress
      @is_crawling = true

      # cloning the uri_seeds
      uri_list = @uri_seeds.clone()

      # clearing the previous crawling results
      @crawling_result.clear()

      # while there are uris to crawl
      while uri_list.length() > 0 do
        # getting the first uri of the list
        curr_uri = uri_list[0]

        # removing the extracted uri from uri_list
        uri_list.delete_at(0)

        # processing the current uri
        processed_uri_result = process_uri(curr_uri)
        # appending it to results if result is valid
        if processed_uri_result != nil then
          @crawling_result << processed_uri_result
        end

        # extracting the uris from the current uri
        new_uris = extract_uris(curr_uri, processed_uri_result)

        # adding the new uris to the seeds list
        for u in new_uris do
          uri_list << u
        end
      end

      # setting flag of not crawling
      @is_crawling = false

      # returning the crawling results
      return @crawling_result
    end

    # gets the uri seeds that are used for crawling
    def get_uri_seeds()
      return @uri_seeds
    end

    # sets the uri seeds that are used for crawling
    def set_uri_seeds(value)
      @uri_seeds = value
    end

    # gets the results obtained in the crawling process
    def get_crawling_result()
      return @crawling_result
    end
end