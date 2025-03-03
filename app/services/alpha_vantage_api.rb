require 'uri'
require 'net/http'
require 'json'

class AlphaVantageApi
  BASE_URL = "https://alpha-vantage.p.rapidapi.com/query".freeze

  def initialize
    @api_key = ENV["RAPIDAPI_KEY"]
  end

  def time_series_intraday(symbol)
    url = URI("#{BASE_URL}?datatype=json&output_size=compact&interval=5min&function=TIME_SERIES_INTRADAY&symbol=#{symbol}")
    response = make_request(url)
    Rails.logger.debug("Raw API Response: #{response.inspect}") # Debug log
    parse_time_series_response(response, symbol)
  end

  private

  def make_request(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = @api_key
    request["x-rapidapi-host"] = 'alpha-vantage.p.rapidapi.com'
    response = http.request(request)
    JSON.parse(response.body)
  end

  def parse_time_series_response(response, symbol)
    # Debug logging
    Rails.logger.debug("Parsing response for symbol: #{symbol}")
    Rails.logger.debug("Response keys: #{response.keys}")

    # Get the time series data
    metadata = response["Meta Data"]
    time_series = response["Time Series (5min)"]

    return nil unless metadata && time_series

    # Get the latest data point
    latest_timestamp = time_series.keys.first
    latest_data = time_series[latest_timestamp]

    Rails.logger.debug("Latest timestamp: #{latest_timestamp}")
    Rails.logger.debug("Latest data: #{latest_data}")

    parsed_data = {
      symbol: symbol,
      latest_day: Time.parse(latest_timestamp).strftime("%B %d, %Y %H:%M:%S"),
      price: latest_data["4. close"],
      open: latest_data["1. open"],
      high: latest_data["2. high"],
      low: latest_data["3. low"],
      volume: latest_data["5. volume"]
    }

    Rails.logger.debug("Parsed data: #{parsed_data}")
    parsed_data
  end
end