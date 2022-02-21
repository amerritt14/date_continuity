require "minitest/autorun"
require "date_continuity/model"
require_relative "./models/contract"
require "pry"

class DateContinuityModelTest < Minitest::Test
  def setup
    @start_at = nil
    @end_at = nil
    @duration = nil
    @time_unit = nil
    @frequency = 1.0
  end

  # Years
  def test_calc_start_at_in_years
    @time_unit = "year"
    @end_at = DateTime.new(2999, 1, 1, 0, 0, 0, "EST")
    @duration = 1000

    assert_equal DateTime.new(2000, 1, 1, 0, 0, 0, "EST"), subject.calc_start_at
  end

  def test_calc_end_at_in_years
    @time_unit = "year"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @duration = 1000

    assert_equal DateTime.new(2999, 1, 1, 0, 0, 0, "EST"), subject.calc_end_at
  end

  def test_calc_duration_in_years
    @time_unit = "year"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @end_at = DateTime.new(2999, 1, 1, 0, 0, 0, "EST")

    assert_equal 1000, subject.calc_duration
  end

  def test_calc_end_at_in_years_with_frequency
    @time_unit = "year"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @duration = 1000
    @frequency = 2.0

    assert_equal DateTime.new(2499, 7, 1, 0, 0, 0, "EST"), subject.calc_end_at
  end

  # Months
  def test_calc_start_at_in_months
    @time_unit = "month"
    @end_at = DateTime.new(2009, 12, 1, 0, 0, 0, "EST")
    @duration = 120

    assert_equal DateTime.new(2000, 1, 1, 0, 0, 0, "EST"), subject.calc_start_at
  end

  def test_calc_end_at_in_months
    @time_unit = "month"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @duration = 120

    assert_equal DateTime.new(2009, 12, 1, 0, 0, 0, "EST"), subject.calc_end_at
  end

  def test_calc_duration_in_months
    @time_unit = "month"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @end_at = DateTime.new(2009, 12, 1, 0, 0, 0, "EST")

    assert_equal 120, subject.calc_duration
  end

  def test_calc_end_at_in_months_with_frequency
    @time_unit = "month"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @duration = 120
    @frequency = 2.0

    assert_equal DateTime.new(2004, 12, 1, 0, 0, 0, "EST"), subject.calc_end_at
  end

  # Weeks
  def test_calc_start_at_in_weeks
    @time_unit = "week"
    @end_at = DateTime.new(2000, 1, 8, 0, 0, 0, "EST")
    @duration = 2

    assert_equal DateTime.new(2000, 1, 1, 0, 0, 0, "EST"), subject.calc_start_at
  end

  def test_calc_end_at_in_weeks
    @time_unit = "week"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @duration = 2

    assert_equal DateTime.new(2000, 1, 8, 0, 0, 0, "EST"), subject.calc_end_at
  end

  def test_calc_duration_in_weeks
    @time_unit = "week"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @end_at = DateTime.new(2000, 1, 8, 0, 0, 0, "EST")

    assert_equal 2, subject.calc_duration
  end

  def test_calc_end_at_in_weeks_with_frequency
    @time_unit = "week"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @duration = 2
    @frequency = 2.0

    assert_equal DateTime.new(2000, 1, 4, 12, 0, 0, "EST"), subject.calc_end_at
  end

  # Days
  def test_calc_start_at_in_days
    @time_unit = "day"
    @end_at = DateTime.new(2004, 12, 31, 0, 0, 0, "EST")
    @duration = 1_827 # 5 years, accounting for 2 leap years

    assert_equal DateTime.new(2000, 1, 1, 0, 0, 0, "EST"), subject.calc_start_at
  end

  def test_calc_end_at_in_days
    @time_unit = "day"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @duration = 1_827 # 5 years, accounting for 2 leap years

    assert_equal DateTime.new(2004, 12, 31, 0, 0, 0, "EST"), subject.calc_end_at
  end

  def test_calc_duration_in_days
    @time_unit = "day"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @end_at = DateTime.new(2004, 12, 31, 0, 0, 0, "EST")

    assert_equal 1_827, subject.calc_duration
  end

  def test_calc_end_at_in_days_with_frequency
    @time_unit = "day"
    @start_at = DateTime.new(2001, 1, 1, 0, 0, 0, "EST")
    @duration = 730 # 2 years without a leap year
    @frequency = 2.0

    assert_equal DateTime.new(2001, 12, 31, 12, 0, 0, "EST"), subject.calc_end_at
  end

  # Hours
  def test_calc_start_at_in_hours
    @time_unit = "hour"
    @end_at = DateTime.new(2000, 1, 7, 23, 0, 0, "EST")
    @duration = 168 # 1 week in hours

    assert_equal DateTime.new(2000, 1, 1, 0, 0, 0, "EST"), subject.calc_start_at
  end

  def test_calc_end_at_in_hours
    @time_unit = "hour"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @duration = 168 # 1 week in hours

    assert_equal DateTime.new(2000, 1, 7, 23, 0, 0, "EST"), subject.calc_end_at
  end

  def test_calc_duration_in_hours
    @time_unit = "hour"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @end_at = DateTime.new(2000, 1, 7, 23, 0, 0, "EST")

    assert_equal 168, subject.calc_duration
  end

  def test_calc_end_at_in_hours_with_frequency
    @time_unit = "hour"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @duration = 48
    @frequency = 2.0

    assert_equal DateTime.new(2000, 1, 1, 23, 30, 0, "EST"), subject.calc_end_at
  end

  # Minutes
  def test_calc_start_at_in_minutes
    @time_unit = "minute"
    @end_at = DateTime.new(2000, 1, 1, 23, 59, 0, "EST")
    @duration = 1_440 # 1 day in minutes

    assert_equal DateTime.new(2000, 1, 1, 0, 0, 0, "EST"), subject.calc_start_at
  end

  def test_calc_end_at_in_minutes
    @time_unit = "minute"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @duration = 1_440 # 1 day in minutes

    assert_equal DateTime.new(2000, 1, 1, 23, 59, 0, "EST"), subject.calc_end_at
  end

  def test_calc_duration_in_minutes
    @time_unit = "minute"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @end_at = DateTime.new(2000, 1, 1, 1, 59, 0, "EST")

    assert_equal 120, subject.calc_duration
  end

  def test_calc_end_at_in_minutes_with_frequency
    @time_unit = "minute"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @duration = 120
    @frequency = 2.0

    assert_equal DateTime.new(2000, 1, 1, 0, 59, 30, "EST"), subject.calc_end_at
  end

  # Seconds
  def test_calc_start_at_in_seconds
    @time_unit = "second"
    @end_at = DateTime.new(2000, 1, 1, 0, 59, 59, "EST")
    @duration = 3_600 # 1 hour in seconds

    assert_equal DateTime.new(2000, 1, 1, 0, 0, 0, "EST"), subject.calc_start_at
  end

  def test_calc_end_at_in_seconds
    @time_unit = "second"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @duration = 3_600 # 1 hour in seconds

    assert_equal DateTime.new(2000, 1, 1, 0, 59, 59, "EST"), subject.calc_end_at
  end

  def test_calc_duration_in_seconds
    @time_unit = "second"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @end_at = DateTime.new(2000, 1, 1, 0, 59, 59, "EST")

    assert_equal 3_600, subject.calc_duration
  end

  def test_calc_end_at_in_seconds_with_frequency
    @time_unit = "second"
    @start_at = DateTime.new(2000, 1, 1, 0, 0, 0, "EST")
    @duration = 1_800
    @frequency = 0.5

    assert_equal DateTime.new(2000, 1, 1, 0, 59, 58, "EST"), subject.calc_end_at
  end

  private

  def subject
    @subject ||= Contract.new(
      start_at: @start_at,
      end_at: @end_at,
      duration: @duration,
      frequency: @frequency,
      time_unit: @time_unit
    )
  end
end
