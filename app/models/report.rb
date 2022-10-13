# frozen_string_literal: true

class Report
  include ActiveModel::Validations
  # TODO: represents the actual report, validate data and implement report methods
  attr_accessor :problematic_dates, :worktime_hrs

  validates :events, :worktime_hrs, :problematic_dates, presence: true

  def initialize(events)
    @events = events
    @worktime_hrs = calculate_worktime_hrs
  end

  def calculate_worktime_hrs
    @problematic_dates = []
    @worked_hours, @time_off = 0, 0
    @events.each_with_index do |event, index|
      problematic_event?(event, index) ? @problematic_dates << event.timestamp.to_date : count_hours(event)
    end

    to_hours(@time_off - @worked_hours)
  end

  def count_hours(event)
    event.kind == 'in' ? @worked_hours += event.timestamp.to_i : @time_off += event.timestamp.to_i
  end

  def problematic_event?(event, index)
    return true if skip_day?(event, index)
    return false if event_with_pair?(event, index)

    true
  end

  def event_with_pair?(event, index)
    return true if event.kind == 'in' && @events[index + 1] && @events[index + 1].kind == 'out'
    return true if event.kind == 'out' && @events[index - 1] && @events[index - 1].kind == 'in'

    false
  end

  def skip_day?(event, index)
    if @events[index + 1] && event.kind == 'in'
      to_hours(@events[index + 1].timestamp - event.timestamp) > 24
    elsif @events[index - 1] && event.kind == 'out'
      to_hours(event.timestamp - @events[index - 1].timestamp) > 24
    else
      false
    end
  end

  def to_hours(time_number)
    (time_number.to_f/3600).round(2)
  end

  def employee_id
    Event.find_by!(employee_id: @params[:employee_id]).employee_id
  end
end
