module HttpFetcher
  def fetch(uri_str, cache = true, limit = 10)
    raise ArgumentError, 'Too many redirections!' if limit == 0

    uri = URI.parse(uri_str)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      begin
        http.get uri.path, { 'Cache-Control' => 'no-cache' }
      rescue
        raise uri_str
      end
    end
    
    case response
    when Net::HTTPSuccess     then response
    when Net::HTTPRedirection then fetch(response['location'], cache, limit - 1)
    else
      response.error!
    end
  end
end
