class ReportsController < ApplicationController
  # GET /reports
  # GET /reports.json
  def index
    # @reports = Report.all
    # @reports = YahooStockAction.all()

    @reports = YahooStockAction.where(:enterprise_id => 1)
    k = 0
  end
end
