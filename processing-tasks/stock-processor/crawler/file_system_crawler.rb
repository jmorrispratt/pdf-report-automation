load './crawler/abstract_crawler.rb'

# represents a filesystem crawler
class FileSystemCrawler < AbstractCrawler
  # implementing only the abstract methods of AbstractCrawler

  # gets a stream from the uri (the content of a local file, of an url, etc.)
  def process_uri(uri)
    # returning nil if the file doesn't exists
    if !File.exist?(uri) then
      return nil
    end

    # if we are in the presence of a directory, we also return nil
    if File.directory?(uri) then
      return nil
    end

    # returning the handle to the uri's content
    return File.new(uri, 'r')
  end

  # extracts new uris that will be added to the uri_seeds
  def extract_uris(uri, uri_content)
    # file must be a directory
    if !File.directory?(uri) then
      return Array.new()
    end

    # creating the new uris container
    new_uris = Array.new()

    # getting the children of the 'uri' folder
    Dir.foreach(uri) do |f|
      # building the new uri path
      path = "#{uri}/#{f}"

      # appending the new uris values if they aren't the '.' and '..' directories
      if f != '.' and f != '..' then
        new_uris << path
      end
    end

    # returning the new uris
    return new_uris
  end
end