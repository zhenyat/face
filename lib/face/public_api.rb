module Face
  ##############################################################################
  #   Sends a request to Face via Public API and returns result as a Hash
  #   (JSON.parse response)
  #   Ref:  https://btc-e.nz/api/3/documentation
  #   
  #   23.07.2017  ZT
  #   31.08.2017  Update with HTTP request error handlig
  #   10.11.2017  Updated to handle secrets
  #   26.04.2022  Adopted
  ##############################################################################
  def self.public_api method, options = {}
    # Hanlde options
    options[:pairs].nil? ? pairs = 'btc_usd' : pairs = options[:pairs]
    limit = options[:limit] unless options[:limit].nil?

    uri =  get_domain + '/api/3'    # Public API URI

    # Just verify method / options
    case method
    when 'info'
      pairs = nil
      limit = nil
    when 'ticker'
      limit = nil
    when 'depth', 'trades'
      # it's OK. both: *pairs* and *limit* to be applied
    else 
      return {:success => 0, :error => "Face Public API: Invalid method"}
    end

    uri =  URI "#{uri}/#{method}/#{pairs}"   # Add Method & Pairs
    
    # Add *limit* e.g. *https://btc-e.nz/api/3/trades/btc_eur?limit=50*    
    uri.query = URI.encode_www_form({:limit => limit}) if !limit.nil? and limit != HTTP_LIMIT

    # Send a request
    begin
      response = Net::HTTP.get(uri)
#    rescue Timeout::Error,       Errno::EINVAL,              Errno::ECONNRESET, EOFError,
#           Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
    rescue StandardError => e
      return {:success => 0, :error => e}
    else
      begin 
        return JSON.parse response
      rescue
        error_msg = "HTTP.get(#{uri}) failed \nTry: Face *debug_connection* or CLI command: http #{uri}"
        return {:success => 0, :error => error_msg}
      end
    end
  end
  
  def self.info
    response = public_api 'info'
    public_error_check response        # Return result through error check at first
  end
 
  ##############################################################################
  # Checks that response is not an error message aka:
  #   {"success":0, "error":"Invalid method"}
  # If error: returns empty hash, otherwise: returns response
  # 
  # caller_locations(1,1)[0].label - the calling method
  ##############################################################################
  def self.public_error_check response
    if response.first.class == Array and response.first[0] == :success and response.first[1] == 0
      puts colored RED, "#{timestamp}  Error in Face method '#{caller_locations(1,1)[0].label}': #{response[:error]}"
      {}
    else
      response
    end
  end

  def self.ticker opts = {}
    response = public_api 'ticker', pairs: opts[:pairs]
    public_error_check response
  end
  
  def self.depth opts = {}
    response = public_api 'depth',  pairs: opts[:pairs], limit: opts[:limit]
    public_error_check response
  end

  def self.trades opts = {}
    response = public_api 'trades', pairs: opts[:pairs], limit: opts[:limit]
    public_error_check response
  end
end
