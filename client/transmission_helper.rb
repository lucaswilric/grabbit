require 'net/http'

require 'rubygems'
require 'json'

class TransmissionHelper
  def initialize(config)
    @transmission_url = config['url']
    @username = config['username']
    @password = config['password']
    
    @session_id = nil
  end
  
  def all_torrents()
    r = JSON.parse get_response("torrent-get", {"fields" => ["id", "name", "downloadDir", "percentDone", "files"]}).body

    if r['result'] == 'success'
      r['arguments']['torrents']
    else
      raise r['result']
    end
  end
  
  def add_torrent(directory, file_name)
    r = JSON.parse get_response("torrent-add", {"filename" => "#{directory}/#{file_name}", "download-dir" => directory}).body

    if r['result'] == 'success'
      r['arguments']['torrent-added']
    else
      raise r['result']
    end
  end
  
  private
  def get_response(method, arguments = nil)
    uri = URI.parse(@transmission_url)
    
    request = Net::HTTP::Post.new(uri.path)
    request.basic_auth @username, @password if @username or @password
    request.body = {"method" => method, "arguments" => arguments}.to_json
    request.add_field 'X-Transmission-Session-Id', @session_id if @session_id
    
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(request)
    end
    
    case response
    when Net::HTTPSuccess
      response
    when Net::HTTPConflict
      @session_id = response['X-Transmission-Session-Id']
      
      get_response(method, arguments)
    else
      response.value
    end
  end
end

