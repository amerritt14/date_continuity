# frozen_string_literal: true

require "active_record"

require "date_continuity/model"

module DateContinuity
  class << self
    attr_accessor :duration_method, :end_method, :frequency_count_method, :start_method, :time_unit_method
  end

  def self.configure
    yield self
  end
end
