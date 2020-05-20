# frozen_string_literal: true

module LogPeriod
  def measure_log_period(date)
    oldest = Time.parse("#{date} 00:00:00").to_i
    latest = Time.parse("#{date} 23:59:59").to_i
    [oldest, latest]
  end
end
