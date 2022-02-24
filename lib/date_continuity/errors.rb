# frozen_string_literal: true

module DateContinuity
  class UnsupportedTimeUnitError < StandardError
    def initialize(time_unit_value)
      super(
        "Unsupported time unit #{time_unit_value}. \
        Must be one of the following: \
        #{DateContinuity::Model::TIME_UNIT_VALUES.to_sentence(last_word_connector: " or ")}".squish
        )
    end
  end

  class NotEnoughInformationError < StandardError
    def initialize(missing_columns)
      super("Missing Information: #{missing_columns.to_sentence} must be set.")
    end
  end
end
