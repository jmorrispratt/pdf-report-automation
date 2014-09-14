require './db_adapters.rb'


# ---------------------------------------------------------------------------------------------------

class AbstractReportGenerator < Object
  # protected members
  protected
    # represents the destination folder where all reports will be saved
    @dst_folder = nil

    # represents an object to communicate with the db
    @db_adapter = nil

  public
    def initialize(db_name, db_user, db_pass, dst_folder: './reports')
      # saving the 'dst_folder' value (by default a folder named reports in the current directory)
      @dst_folder = dst_folder

      # creating the db_adapter
      @db_adapter = PgStocksDbAdapter.new(db_name, db_user, db_pass)
    end

    def get_operative_details(report_name, client_ticker, start_date, end_date)
      # empty --> this is like an abstract class method
    end
end

# ---------------------------------------------------------------------------------------------------

# represents an html report generator
class HtmlReportGenerator < AbstractReportGenerator
  # implementing only the abstract methods of AbstractReportGenerator

  def initialize(db_name, db_user, db_pass, dst_folder: './reports')
    # calling base constructor
    super(db_name, db_user, db_pass, dst_folder: dst_folder)

    # initilize necessary methods for this report generator
  end

  def get_operative_details(report_name, client_ticker, start_date, end_date)
    # getting the information from db
    details_result = @db_adapter.get_operative_details(client_ticker, start_date, end_date)

    # buyer's operative details
    buyers_details = details_result[0]
    buyers_details_content = ''
    buyers_details.each do |row|
      buyers_details_content += "<li>#{row['contribution']}%\t#{row['mediator_name']}</li>\n"
    end

    # seller's operative details
    sellers_details = details_result[1]
    sellers_details_content = ''
    sellers_details.each do |row|
      sellers_details_content  += "<li>#{row['contribution']}%\t#{row['mediator_name']}</li>\n"
    end

    # --------------------------------------------------------------------------------------------

    # the html template
    html_content =
"
  <html>
    <head>
      <title>#{report_name}</title>
    </head>

    <!-- --------------------------------------------- -->

    <body>
      <!-- general information here -->
      <h2>
        <b>Stock Owner:</b>#{client_ticker}
      </h2>
      <h2>
        <b>Starting Date:</b>#{start_date.to_s()}
      </h2>
      <h2>
        <b>Ending Date:</b>#{end_date.to_s()}
      </h2>

      <hr/>

      <!-- buyer's operative data here -->
      <h3>
        <b>Buyer's Operative Details:</b>
      </h3>

      <ol>
#{buyers_details_content}
      </ol>

      <hr/>

      <!-- sellers's operative data here -->
      <h3>
        <b>Seller's Operative Details:</b>
      </h3>

      <ol>
#{sellers_details_content}
      </ol>

      <!-- footer here -->
      <hr/>
      <p>Copyright <b>Irstrat</b> #{Time.now().to_s()}</p>
    <body>
  </html>
"

    # returning the result
    return html_content
  end
end

# ---------------------------------------------------------------------------------------------------

# represents a pdf report generator
class PdfReportGenerator < AbstractReportGenerator
  # implementing only the abstract methods of AbstractReportGenerator

  def initialize(db_name, db_user, db_pass, dst_folder: './reports')
    # calling base constructor
    super(db_name, db_user, db_pass, dst_folder: dst_folder)

    # initilize necessary methods for this report generator
  end
end

# ---------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------