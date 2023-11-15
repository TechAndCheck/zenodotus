module Admin::WebScrapeHelper
  def integer_to_time_duration(integer)
    # We rely on this number being an integer so division always results in an integer result too
    minutes = integer / 60
    seconds = integer % 60
    hours = minutes / 60
    minutes = minutes % 60
    days = hours / 24
    hours = hours % 24

    return_string = "#{seconds}s"
    return_string = "#{minutes}m #{return_string}" unless minutes.zero?
    return_string = "#{hours}h #{return_string}" unless hours.zero?
    return_string = "#{days}d #{return_string}" unless days.zero?

    return_string
  end
end
