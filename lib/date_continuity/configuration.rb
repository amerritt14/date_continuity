# frozen_string_literal: true

module DateContinuity
  class Configuration
    attr_accessor :time_unit_method, :frequency_count_method

    def self.setup
      new.tap do |instance|
        yield(instance) if block_given?
      end
    end

    def initialize
      @time_unit_method = :time_unit
      @frequency_count_method = :frequency
    end
  end
end
