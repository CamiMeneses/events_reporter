# frozen_string_literal: true

class Event < ApplicationRecord
  validates :employee_id, :timestamp, :kind, presence: true
  enum kind: { in: 0, out: 1 }

  default_scope { order(timestamp: :asc) }

  scope :by_date, ->(start_date, end_date) do
    where(timestamp: DateTime.parse(start_date)..DateTime.parse(end_date).end_of_day)
  end
end
