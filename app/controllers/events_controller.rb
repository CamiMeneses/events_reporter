# frozen_string_literal: true

class EventsController < ApplicationController
  def save
    Event.create!(event_params.slice(:employee_id, :kind).merge(timestamp: date))
    render  status: :ok
  rescue => e
    render json: { message: e.message },
           status: :bad_request
  end

  private

  def date
    Time.zone.at(event_params[:timestamp].to_i)
  end

  def event_params
    params.permit(:employee_id, :timestamp, :kind)
  end
end
