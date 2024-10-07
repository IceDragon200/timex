defmodule Timex.Calendar.JulianTest do
  use ExUnit.Case, async: true
  alias Timex.Calendar.Julian

  # test values generated from:
  # http://aa.usno.navy.mil/data/docs/JulianDate.php

  test "Test Julian Date" do
    assert Julian.julian_date(2018, 10, 1) == 2_458_393
  end

  test "Test Julian Date right after midnight" do
    assert Julian.julian_date(2018, 10, 1, 0, 0, 1) == 2_458_392.500011574
  end

  test "Test Julian Date at noon" do
    assert Julian.julian_date(2018, 10, 1, 12, 0, 0) == 2_458_393
  end

  test "Test Julian Date morning hour" do
    assert Julian.julian_date(2018, 10, 1, 6, 0, 0) == 2_458_392.75
  end

  test "Test Julian Date evening hour" do
    assert Julian.julian_date(2018, 10, 1, 18, 0, 0) == 2_458_393.25
  end

  test "day_of_week starting sunday" do
    # {2017, 1, 1} was a sunday
    day_numbers = for day <- 1..7, do: Julian.day_of_week({2017, 1, day}, :sun)
    assert day_numbers == Enum.to_list(0..6)
  end

  test "day_of_week starting monday" do
    # {2017, 1, 2} was a monday
    day_numbers = for day <- 2..8, do: Julian.day_of_week({2017, 1, day}, :mon)
    assert day_numbers == Enum.to_list(1..7)
  end

  test "julian day of year, leap year, leaps disallowed" do
    assert ~D[2020-02-28] = Julian.date_for_day_of_year(59, 2020)
    assert ~D[2020-03-01] = Julian.date_for_day_of_year(60, 2020)
  end

  test "julian day of year, non-leap year, leaps disallowed" do
    assert ~D[2021-02-28] = Julian.date_for_day_of_year(59, 2021)
    assert ~D[2021-03-01] = Julian.date_for_day_of_year(60, 2021)
  end

  test "julian day of year, leap year, leaps allowed" do
    assert ~D[2020-02-28] = Julian.date_for_day_of_year(58, 2020, leaps: true)
    assert ~D[2020-02-29] = Julian.date_for_day_of_year(59, 2020, leaps: true)
    assert ~D[2020-03-01] = Julian.date_for_day_of_year(60, 2020, leaps: true)
  end

  test "julian day of year, non-leap year, leaps allowed" do
    assert ~D[2021-02-28] = Julian.date_for_day_of_year(58, 2021, leaps: true)
    assert ~D[2021-03-01] = Julian.date_for_day_of_year(59, 2021, leaps: true)
    assert ~D[2021-03-02] = Julian.date_for_day_of_year(60, 2021, leaps: true)
  end
end
