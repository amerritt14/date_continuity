# frozen_string_literal: true

require "date_continuity"

class Contract
  include DateContinuity::Model

  attr_accessor :start_at, :end_at, :duration, :frequency, :time_unit

  def initialize(start_at:, end_at:, duration:, frequency:, time_unit:)
    @start_at = start_at
    @end_at = end_at
    @duration = duration
    @frequency = frequency
    @time_unit = time_unit
  end
end
