# frozen_string_literal: true

module DateContinuity
  module Occurrences
    extend ActiveSupport::Concern

    def all_occurrences
      if start_value.present? && duration_value.present?
        Array.new(duration_value) do |count|
          start_value + duration_object(count)
        end
      else
        _raise_not_enough_information_error [start_method, duration_method]
      end
    end

    def prev_occurrence(current_time = DateTime.current)
      set_start if start_value.blank?
      current_time = current_time.beginning_of_day unless time_unit_less_than_day?
      return if start_value >= current_time

      duration_from_start_to_now = calc_duration(start_value, current_time) - 1
      start_value + duration_object(duration_from_start_to_now)
    end

    def next_occurrence(current_time = DateTime.current)
      set_end if end_value.blank?
      current_time = current_time.beginning_of_day unless time_unit_less_than_day?
      return if current_time >= end_value
      return start_value unless prev_occurrence(current_time)

      prev_occurrence(current_time) + interval_object
    end
  end
end
