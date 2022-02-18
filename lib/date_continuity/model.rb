# frozen_string_literal: true

module DateContinuity
  module Model
    TIME_UNIT_VALUES = %w(second minute hour day week month year).freeze
    DAY_EQUIVALENTS = {
      second: 86_400,
      minute: 1_440,
      hour: 24,
      day: 1,
      week: 7,
      month: 30,
      year: 365
    }.freeze

    class UnsupportedTimeUnitError < StandardError; end
    class NotEnoughInformationError < StandardError; end

    extend ActiveSupport::Concern

    included do
      class_attribute :duration_column, :start_column, :end_column
      class_attribute :time_unit_method, :frequency_count_method
      self.duration_column = :duration
      self.start_column = :start_on
      self.end_column = :end_on
      self.time_unit_method = :time_unit
      self.frequency_count_method = :frequency
    end

    def duration_object
      (duration_value - 1).public_send(time_unit_value)
    end

    def calc_end_on
      if start_value.present? && duration_value.present?
        start_value + (duration_object / frequency_value)
      else
        _raise_not_enough_information_error %w(start_value duration_value)
      end
    end

    def calc_start_on
      if end_value.present? && duration_value.present?
        end_value - (duration_object / frequency_value)
      else
        _raise_not_enough_information_error %w(end_value duration_value)
      end
    end

    def calc_duration
      # DateTime subtraction returns a fraction representing days
      if start_value.present && end_value.present?
        (end_value - start_value) * DAY_EQUIVALENTS[time_unit_value]
      else
        _raise_not_enough_information_error %w(start_value end_value)
      end
    end

    private

    # Getter methods
    def start_value
      public_send(start_column)&.to_datetime
    end

    def end_value
      public_send(end_column)&.to_datetime
    end

    def duration_value
      public_send(duration_column).to_i
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
