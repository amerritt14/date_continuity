# frozen_string_literal: true

module DateContinuity
  module Model
    FREQUENCY_VALUES = %w(days weeks months years)
    class UnsupportedFrequencyError < StandardError; end
    extend ActiveSupport::Concern

    included do
      class_attribute :duration_column, :start_column, :end_column
      class_attribute :frequency_method
      self.duration_column = :duration
      self.start_column = :start_on
      self.end_column = :end_on
      self.frequency_method = :frequency

      validate :frequency_method_values
    end

    def duration_object
      duration_value.public_send(frequency_value)
    end

    private

    def duration_value
      public_send(duration_column).to_i
    end

    def frequency_value
      send(frequency_method).tap do |value|
        unless FREQUENCY_VALUES.include?(value)
          raise UnsupportedFrequencyError.new("Frequency must be one of #{FREQUENCY_VALUES.join(', ')}")
        end
      end
    end
  end
end
