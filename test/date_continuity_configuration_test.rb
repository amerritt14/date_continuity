require "minitest/autorun"
require "date_continuity/model"

class DateContinuityConfigurationTest < Minitest::Test
  def teardown
    # Reset configuration between runs
    DateContinuity.configuration = DateContinuity::Configuration.new
  end

  def test_duration_method_can_be_configured
    DateContinuity.configure { |config| config.duration_method = :foo }

    assert_equal :foo, subject.duration_method
  end

  def test_end_method_can_be_configured
    DateContinuity.configure { |config| config.end_method = :foo }

    assert_equal :foo, subject.end_method
  end

  def test_frequency_count_method_can_be_configured
    DateContinuity.configure { |config| config.frequency_count_method = :foo }

    assert_equal :foo, subject.frequency_count_method
  end

  def test_start_method_can_be_configured
    DateContinuity.configure { |config| config.start_method = :foo }

    assert_equal :foo, subject.start_method
  end

  def test_time_unit_method_can_be_configured
    DateContinuity.configure { |config| config.time_unit_method = :foo }

    assert_equal :foo, subject.time_unit_method
  end

  def test_duration_method_has_expected_default
    assert_equal :duration, subject.duration_method
  end

  def test_end_method_has_expected_default
    assert_equal :end_at, subject.end_method
  end

  def test_frequency_count_method_has_expected_default
    assert_equal :frequency, subject.frequency_count_method
  end

  def test_start_method_has_expected_default
    assert_equal :start_at, subject.start_method
  end

  def test_time_unit_method_has_expected_default
    assert_equal :time_unit, subject.time_unit_method
  end

  private

  def subject
    @subject ||= DateContinuity.configuration
  end
end
