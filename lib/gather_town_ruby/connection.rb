require "httparty"

class GatherTown::Connection
  include HTTParty

  base_uri 'https://gather.town/api'

  attr_reader   :space_id
  attr_accessor :map_id

  def initialize(web_url, map_id: nil, test_connection: true)
    validate_api_key
    validate_web_url web_url
    set_space_id_from web_url
    set_map_id_from map_id
    self.class.default_params **default_query_params # sets the default params for HTTParty requests
    get_map if test_connection
  end

  def get_map
    return_as(GatherTown::Map) do
      self.class.get "/getMap" 
    end
  end

  def set_map(updated_map)
    return_as(nil) do
      self.class.post "/setMap", { 
        body: { 
          mapContent: updated_map_as_json(updated_map) 
        }
      }
    end
  end


  private
  

  def updated_map_as_json(updated_map)
    if updated_map.is_a? GatherTown::Map
      return updated_map.to_json
    else
      raise ArgumentError, "must pass either a GatherTown::Map or a string that parses to valid JSON" unless JSON.parse(updated_map)
      return updated_map
    end 
  end

  def api_key
    ENV['GATHER_API_KEY'] || raise(ArgumentError, "no API key was found (did you set ENV['GATHER_API_KEY']?)")
  end
  alias :validate_api_key :api_key

  def valid_web_url_prefix
    'https://app.gather.town/app/'
  end

  def validate_web_url(web_url)
    raise ArgumentError, "must pass a web URL like 'https://app.gather.town/app/PppGRSubDWjPmcQM/Your%20Office'. You can just copy this from your browser once you're logged in to Gather" unless web_url
    raise ArgumentError, "web_url must be a String" unless web_url.is_a?(String)
    raise ArgumentError, "web_url ('#{web_url}') must begin with '#{valid_web_url_prefix}'" unless web_url[0..(valid_web_url_prefix.length - 1)] == valid_web_url_prefix
  end

  def set_space_id_from(web_url)
    raw_space_id_and_name = web_url[valid_web_url_prefix.length..-1]
    raise ArgumentError, "web_url must end with a space id and a space name, separated by a `/` character" unless raw_space_id_and_name.include?('/') && raw_space_id_and_name.split('/').all?
    space_id       = raw_space_id_and_name.split('/').first
    raw_space_name = raw_space_id_and_name.split('/').last
    space_name = (not_encoded?(raw_space_name) ? encode(raw_space_name) : raw_space_name)
    @space_id = [space_id, space_name].join("\\") # as per Gather's API spec, the space ID and space name must be separated by a backslash (not a forward slash, as in the URL)
  end

  def set_map_id_from(map_id)
    raise ArgumentError, "must pass a map ID, like 'office-cozy' (you can find a valid map ID by opening the 'Mapmaker', and looking in the 'Rooms' tab on the right)" unless map_id && map_id.is_a?(String)
    @map_id = map_id
  end

  def not_encoded?(string)
    string == CGI.unescape(string)
  end

  def encode(string)
    ERB::Util.url_encode(string)
  end

  def default_query_params
    { 
      apiKey:  api_key, 
      spaceId: @space_id,
      mapId:   @map_id,
      headers: { 
        'Content-Type' => 'application/json',
        'Accept'       => 'application/json'
      }
    }
  end

  # We're overwritting the query_string_normalizer method in HTTParty so that 
  # the single backslash in the @space_id isn't escaped.
  query_string_normalizer proc { |query|
    query.map do |key, value|
      [value].flatten.map {|v| "#{key}=#{v}"}.join('&')
    end.join('&')
  }

  def return_as(klass, &block)
    response = yield
    if response.header.is_a?(Net::HTTPSuccess)
      if klass
        klass.new(response.parsed_response)
      else
        true
      end
    else
      raise ArgumentError, "\nthe request:\n  #{response.request.inspect}\nyielded an unsuccessful response:\n  #{response.header}: #{response.parsed_response}"
    end
  end

end