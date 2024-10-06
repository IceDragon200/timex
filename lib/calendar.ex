defmodule Timex.Calendar do 
  @seconds_per_day 24 * 60 * 60

  @type year :: integer()
  @type month :: 1..12
  @type ldom :: 28..31

  defdelegate leap_year?(year), to: Calendar.ISO
  defdelegate valid_date?(year, month, day), to: Calendar.ISO

  def valid_date?({y, m, d}), do: valid_date?(y, m, d)

  @spec last_day_of_the_month(year(), month()) :: ldom()
  def last_day_of_the_month(_y, 4), do: 30
  def last_day_of_the_month(_y, 6), do: 30
  def last_day_of_the_month(_y, 9), do: 30
  def last_day_of_the_month(_y, 11), do: 30
  def last_day_of_the_month(y, 2) do
    if leap_year?(y) do
      29
    else
      28
    end
  end
  def last_day_of_the_month(_y, m) when m > 0 and m < 13 do
    31
  end

  def datetime_to_gregorian_seconds({{y, m, d}, time}) do
    @seconds_per_day * Calendar.ISO.date_to_iso_days(y, m, d) + :calendar.time_to_seconds(time)
  end

  def gregorian_seconds_to_datetime(secs) do
    iso_days = div(secs, @seconds_per_day)
    secs = rem(secs, @seconds_per_day)
    date = Calendar.ISO.date_from_iso_days(iso_days)
    time = :calendar.seconds_to_time(secs)
    {date, time}
  end
end
