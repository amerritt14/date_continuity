# frozen_string_literal: true

module DateContinuity
  module TimeBetween
    extend ActiveSupport::Concern

    def months_between(date1, date2)
      earlier, later = [date1, date2].sort
      (later.year - earlier.year) * 12 + later.month - earlier.month
    end

    def years_between(date1, date2)
      earlier, later = [date1, date2].sort
      diff = (later.year - earlier.year)

      if earlier.month > later.month
        diff -= 1
      elsif earlier.month == later.month
        if earlier.end_of_month == earlier && later.end_of_month == later
          # no-op, account for leap years
        elsif earlier.day > later.day
          diff -= 1
        end
      end

      diff
    end
  end
end
