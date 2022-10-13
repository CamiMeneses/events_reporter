# frozen_string_literal: true

class ReportsController < ApplicationController
  def get
    report_generator = ReportGenerator.new(params).call
    render json: report_generator
  rescue => e
    render json: { message: e.message },
           status: :bad_request
  end
end
