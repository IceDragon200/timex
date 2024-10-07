defmodule Timex.Calendar do 
  @seconds_per_minute 60

  @seconds_per_hour 60 * @seconds_per_minute

  @seconds_per_day 24 * @seconds_per_hour

  @type year :: integer()
  @type month :: 1..12
  @type ldom :: 28..31

  defdelegate leap_year?(year), to: Calendar.ISO
  defdelegate valid_date?(year, month, day), to: Calendar.ISO

  def valid_date?({y, m, d}), do: valid_date?(y, m, d)

  @spec seconds_to_time(integer()) :: :calendar.time()
  def seconds_to_time(secs) when is_integer(secs) do
    secs = rem(secs, @seconds_per_day)
    secs =
      if secs < 0 do
        @seconds_per_day + secs
      else
        secs
      end

    hour = div(secs, @seconds_per_hour)
    minute =
      secs
      |> div(@seconds_per_minute)
      |> rem(@seconds_per_minute)
    sec = rem(secs, @seconds_per_minute)
    {hour, minute, sec}
  end

  def datetime_to_gregorian_seconds({{y, m, d}, time}) do
    @seconds_per_day * Calendar.ISO.date_to_iso_days(y, m, d) + :calendar.time_to_seconds(time)
  end

  def gregorian_seconds_to_datetime(secs) do
    iso_days =
      if secs < 0 do
        div(secs, @seconds_per_day) - 1
      else
        div(secs, @seconds_per_day)
      end
    secs = rem(secs, @seconds_per_day)
    date = Calendar.ISO.date_from_iso_days(iso_days)
    time = seconds_to_time(secs)
    {date, time}
  end
end
