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
      week: (1.0 / 7.0)
    }.freeze

    extend ActiveSupport::Concern

    delegate :duration_method, :end_method, :frequency_count_method,
             :start_method, :time_unit_method, to: :config

    included do
      alias_method "calc_#{DateContinuity.configuration.duration_method}".to_sym, :calc_duration
      alias_method "calc_#{DateContinuity.configuration.end_method}".to_sym, :calc_end
      alias_method "calc_#{DateContinuity.configuration.start_method}".to_sym, :calc_start
    end

    def duration_object
      ((duration_value - 1).public_send(time_unit_value) / frequency_value)
    end

    def calc_end
      if start_value.present? && duration_value.present?
        start_value + duration_object
      else
        _raise_not_enough_information_error [start_method, duration_method]
      end
    end

    def calc_start
      if end_value.present? && duration_value.present?
        end_value - duration_object
      else
        _raise_not_enough_information_error [end_method, duration_method]
      end
    end

    def calc_duration
      # DateTime subtraction returns a fraction representing days
      _raise_not_enough_information_error [start_method, end_method] unless start_value.present? && end_value.present?

      @duration = case time_unit_value
                  when "month"
                    months_between(start_value, end_value)
                  when "year"
                    years_between(start_value, end_value)
                  else
                    (end_value - start_value) * DAY_EQUIVALENTS[time_unit_value.to_sym]
                  end + 1
      (@duration * frequency_value).to_i
    end

    def set_duration
      send("#{duration_method}=", calc_duration)
    end

    private

    def config
      @config ||= DateContinuity.configuration
    end

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
        _raise_unsupported_time_unit_error(value) unless TIME_UNIT_VALUES.include?(value)
      end
    end

    # Exceptions
    def _raise_unsupported_time_unit_error(value)
      raise UnsupportedTimeUnitError.new(value)
    end

    def _raise_not_enough_information_error(required_columns)
      raise NotEnoughInformationError.new(required_columns)
    end
  end
end
