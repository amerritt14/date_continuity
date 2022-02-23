# frozen_string_literal: true

module DateContinuity
  class Configuration
    attr_accessor :duration_method, :end_method, :frequency_count_method, :start_method, :time_unit_method

    def initialize
      @duration_method = :duration
      @end_method = :end_at
      @frequency_count_method = :frequency
      @start_method = :start_at
      @time_unit_method = :time_unit
    end
  end
end
