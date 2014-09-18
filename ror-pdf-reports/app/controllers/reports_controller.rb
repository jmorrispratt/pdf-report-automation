class ReportsController < ApplicationController
  # GET /reports
  # GET /reports.json
  def index
    # @reports = Report.all
    # @reports = YahooStockAction.all()

    @reports = YahooStockAction.where(:enterprise_id => 1)

    # getting the records of the company we're interested in
    # q_result = YahooStockAction.get_actions_enterprise_with_id(1)
  end
end
