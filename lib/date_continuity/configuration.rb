# frozen_string_literal: true

module DateContinuity
  class Configuration
    attr_accessor :frequency_method

    def self.setup
      new.tap do |instance|
        yield(instance) if block_given?
      end
    end

    def initialize
      @frequency_method = :frequency
    end
  end
end
