defmodule Timex.CalendarTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  alias Timex.Calendar

  describe "gregorian_seconds_to_datetime/1" do
    test "zero" do
      assert {{0, 1, 1}, {0, 0, 0}} == Calendar.gregorian_seconds_to_datetime(0)
    end

    test "before zero" do
      assert {{-1, 12, 31}, {23, 59, 59}} == Calendar.gregorian_seconds_to_datetime(-1)
    end
  end

  property "behaves like its :calendar equilvalent for positive dates" do
    check all(
      naive <- PropertyHelpers.date_time_generator(:tuple)
    ) do
      secs = Calendar.datetime_to_gregorian_seconds(naive)
      assert secs == :calendar.datetime_to_gregorian_seconds(naive)
      naive = Calendar.gregorian_seconds_to_datetime(secs)
      assert naive == :calendar.gregorian_seconds_to_datetime(secs)
    end
  end

  property "datetime to and from gregorian_seconds for negative dates" do
    check all(
      naive <- PropertyHelpers.neg_date_time_generator(:tuple)
    ) do
      secs = Calendar.datetime_to_gregorian_seconds(naive)
      assert naive == Calendar.gregorian_seconds_to_datetime(secs)
    end
  end
end
