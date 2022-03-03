# frozen_string_literal: true

require "active_support/all"
require "date_continuity/errors"
require "date_continuity/time_between"
require "date_continuity/occurrences"

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
      include DateContinuity::Errors
      include DateContinuity::TimeBetween
      include DateContinuity::Occurrences

      alias_method "calc_#{DateContinuity.configuration.duration_method}".to_sym, :calc_duration
      alias_method "calc_#{DateContinuity.configuration.end_method}".to_sym, :calc_end
      alias_method "calc_#{DateContinuity.configuration.start_method}".to_sym, :calc_start
    end

    # Calculation Methods

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

    def calc_duration(start_datetime = start_value, end_datetime = end_value)
      # DateTime subtraction returns a fraction representing days
      if start_datetime && end_datetime
        duration = case time_unit_value
                    when "month" then months_between(start_datetime, end_datetime)
                    when "year" then years_between(start_datetime, end_datetime)
                    else
                      (end_datetime - start_datetime) * DAY_EQUIVALENTS[time_unit_value.to_sym]
                    end + 1
        (duration * frequency_value).to_i
      else
        _raise_not_enough_information_error [start_method, end_method]
      end
    end

    def duration_object(duration = duration_value - 1)
      (duration.public_send(time_unit_value) / frequency_value)
    end

    # Setter methods

    def set_duration
      send("#{duration_method}=", calc_duration)
      self
    end

    def set_end
      send("#{end_method}=", calc_end)
      self
    end

    def set_start
      send("#{start_method}=", calc_start)
      self
    end

    private

    def config
      @config ||= DateContinuity.configuration
    end

    def interval_object
      1.public_send(time_unit_value) / frequency_value
    end

    def time_unit_less_than_day?
      DAY_EQUIVALENTS[time_unit_value.to_sym] && DAY_EQUIVALENTS[time_unit_value.to_sym] < 1
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
      send(time_unit_method).downcase.singularize.tap do |value|
        _raise_unsupported_time_unit_error(value) unless TIME_UNIT_VALUES.include?(value)
      end
    end
  end
end
