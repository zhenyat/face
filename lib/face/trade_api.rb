module Face
  ##############################################################################
  #   Sends a request to BTCE Hash via Trade API 1 and returns result as a 
  #   Ref:  https://wex.nz/tapi/docs#main
  #
  #   Args:
  #         method  - Name of the calling API Method
  #         options - List of HTTP request parameters. 
  #                   Generated by the calling Method
  #   
  #   25.07.2017  Created
  #   10.11.2017  Updated to handle secrets
  #   24.02.2018  Methods Trade & CancelOrder added
  #   27.02.2018  `trade_error_check` updated
  #   28.04.2022  Adopted
  ##############################################################################
  def self.trade_api method, options = {}

    # Generate list of API parameters for HTTP request
    final_hash = {"method" => method, "nonce" => nonce}.merge options
    api_params = URI.encode_www_form(final_hash)

    signature  = OpenSSL::HMAC.hexdigest('sha512', get_secret, api_params)
    
    # Send the request and return the result
    Net::HTTP.start(get_domain.split('//').last, 443, :use_ssl => true) do |http|
      headers  = {'Sign' => signature, 'Key' => get_key}
      response = http.post('/tapi', api_params, headers).body
      return JSON.parse(response) 
    end
  end
  
  def self.account_info
    trade_error_check trade_api('getInfo')
  end
  
  def self.active_orders opts = {}
    if opts['mode'].nil?
      trade_error_check trade_api('ActiveOrders', opts)
    else
      trade_error_check trade_emulator('ActiveOrders', opts)
    end
  end
  
  def self.cancel_order opts = {}
    trade_error_check trade_api('CancelOrder', opts)
  end
    
  def self.order_info order_id, opts = {}
    if opts['mode'].nil?
      trade_error_check trade_api('OrderInfo', 'order_id' =>  order_id)
    else
      trade_error_check trade_emulator('OrderInfo', opts)
    end
  end

  ##############################################################################
  # The basic method that can be used for creating orders and trading on the exchange
  # 
  # Parameters:
  #   pair	 - pair	(e.g. btc_usd)
  #   type	 - order type	buy or sell
  #   rate	 - the rate at which you need to buy/sell	- numerical
  #   amount - the amount you need to buy / sell      - numerical
  ##############################################################################
  def self.trade opts = {}
    trade_error_check trade_api('Trade', opts)
  end
  
  ##############################################################################
  # Checks that response is not an error message like:
  #   {"success": 0, "error": "no orders"}
  # If error: returns empty hash, otherwise: returns response
  # 
  # caller_locations(1,1)[0].label - the calling method
  # 
  # 27.02.2018  Updated
  ##############################################################################  
  def self.trade_error_check response
    if response.first[1] == 0  # status = 0
      puts colored RED, "#{timestamp}  Error in method '#{caller_locations(1,1)[0].label}': #{response['error']}"
#      {}
      response    # Error returned for further handling
    else
      response    # Data returned
    end
  end
end
