# frozen_string_literal: true

require "active_record"

require "date_continuity/configuration"
require "date_continuity/model"

module DateContinuity
  def self.configuration
    @configuration ||= DateContinuity::Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
