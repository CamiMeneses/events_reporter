# frozen_string_literal: true

class ReportGenerator
  # TODO: - fetch range of events and generate Report
  def initialize(params)
    @params = params
  end

  def call
    {
      employee_id: employee_id,
      from: @params[:from],
      to: @params[:to],
      worktime_hrs: report.worktime_hrs,
      problematic_dates: report.problematic_dates
    }
  end

  private

  def report
    @report ||= Report.new(events)
  end

  def employee_id
    Event.find_by!(employee_id: @params[:employee_id]).employee_id
  end

  def events
    Event.by_date(@params[:from], @params[:to])
  end
end
