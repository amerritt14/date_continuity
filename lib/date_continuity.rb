# frozen_string_literal: true

require "active_record"

require "date_continuity/configuration"
require "date_continuity/model"

module DateContinuity
  @config = DateContinuity::Configuration.setup

  class << self
    extend Forwardable

    attr_reader :config

    # Configurable options
    def_delegators :@config, :frequency_method, :frequency_method=
  end
end
