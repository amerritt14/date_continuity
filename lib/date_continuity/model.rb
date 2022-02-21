# frozen_string_literal: true

require "active_support/all"

module DateContinuity
  module Model
    TIME_UNIT_VALUES = %w(second minute hour day week month year).freeze
    DAY_EQUIVALENTS = {
      second: 86_400,
      minute: 1_440,
      hour: 24,
      day: 1,
      week: (1.0 / 7)
    }.freeze

    class UnsupportedTimeUnitError < StandardError; end

    class NotEnoughInformationError < StandardError; end

    extend ActiveSupport::Concern

    included do
      class_attribute :duration_method, :end_method, :frequency_count_method, :start_method, :time_unit_method

      self.duration_method = DateContinuity.duration_method || :duration
      self.start_method = DateContinuity.start_method || :start_at
      self.end_method = DateContinuity.end_method || :end_at
      self.time_unit_method = DateContinuity.time_unit_method || :time_unit
      self.frequency_count_method = DateContinuity.frequency_count_method || :frequency

      alias_method "calc_#{duration_method}".to_sym, :calc_duration
      alias_method "calc_#{end_method}".to_sym, :calc_end
      alias_method "calc_#{start_method}".to_sym, :calc_start
    end

    def duration_object
      (duration_value - 1).public_send(time_unit_value)
    end

    def calc_end
      if start_value.present? && duration_value.present?
        start_value + (duration_object / frequency_value)
      else
        _raise_not_enough_information_error %w(start_value duration_value)
      end
    end

    def calc_start
      if end_value.present? && duration_value.present?
        end_value - (duration_object / frequency_value)
      else
        _raise_not_enough_information_error %w(end_value duration_value)
      end
    end

    def calc_duration
      # DateTime subtraction returns a fraction representing days
      _raise_not_enough_information_error %w(start_value end_value) unless start_value.present? && end_value.present?

      @duration = case time_unit_value
                  when "month"
                    months_between(start_value, end_value)
                  when "year"
                    years_between(start_value, end_value)
                  else
                    (end_value - start_value) * DAY_EQUIVALENTS[time_unit_value.to_sym]
                  end + 1
      @duration.to_i
    end

    def set_duration
      send("#{duration_method}=", calc_duration)
    end

    private

    # Calculations
    def months_between(date1, date2)
      earlier, later = [date1, date2].sort
      (later.year - earlier.year) * 12 + later.month - earlier.month
    end

    def years_between(date1, date2)
      earlier, later = [date1, date2].sort
      diff = (later.year - earlier.year)

      if earlier.month > later.month
        diff -= 1
      elsif earlier.month == later.month
        if earlier.end_of_month == earlier && later.end_of_month == later
          # no-op, account for leap years
        elsif earlier.day > later.day
          diff -= 1
        end
      end

      diff
    end

    # Getter methods
    def start_value
      public_send(start_method)&.to_datetime
    end

    def end_value
      public_send(end_method)&.to_datetime
    end

    def duration_value
      public_send(duration_method).to_i
    end

    def frequency_value
      if respond_to?(frequency_count_method)
        send(frequency_count_method).to_f
      else
        1.0
      end
    end

    def time_unit_value
      send(time_unit_method).tap do |value|
        _raise_unsupported_time_unit_error unless TIME_UNIT_VALUES.include?(value)
      end
    end

    # Exceptions
    def _raise_unsupported_time_unit_error
      raise UnsupportedTimeUnitError.new("TimeUnit must be one of #{TIME_UNIT_VALUES.join(', ')}")
    end

    def _raise_not_enough_information_error(required_columns)
      raise NotEnoughInformationError.new("#{required_columns.join(', ')} must be set")
    end
  end
end
