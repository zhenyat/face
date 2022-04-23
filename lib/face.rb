# frozen_string_literal: true

require 'yaml'
require 'json'
require 'cgi'
require 'openssl'
require 'net/http'

require_relative 'face/version'
require_relative 'face/setpar'
require_relative 'face/methods_pool'
# require_relative 'face/get_data'
# require_relative 'face/public_api'
# require_relative 'face/trade_api'
# require_relative 'face/trade_emulator'
# require_relative 'face/debug_connection'

module Face
  class Error < StandardError; end

  class CliTest
    ##############################################################
    # First test:
    #   % irb
    #   > require 'face'
    #   > Face::CliTest.say_hello
    ##############################################################
    def self.say_hello
      puts Face::colored BLUE, "Hello from Face (v. #{Face::VERSION})! Just first test" 
    end
  end

  # For test with Rails App
  class Demo
    AppRoot = `pwd`.chomp
    def self.get_message
      "#{AppRoot}: message from Face v. #{Face::VERSION}"
    end
  end

  def self.error_check response
    if !response.nil?
      if response.first[0] == 'success' and response.first[1] == 0
        puts colored RED, "#{timestamp}  #{response['error']}"
        {}
      else
        response
      end
    end
  end
  
#  error_check debug_connection

#####  Testing Public API   #####
#  puts "-----   info   ------"
#  puts info

#  puts "-----   ticker   ------"
#  puts ticker pairs: 'btc_rur-btc_eur-btc_usd'
#  puts ticker.to_json
  
#  puts "-----   depth   ------"
#  puts depth pairs: 'btc_rur', limit: 20
 
#  puts "-----   trades   ------"
#  puts trades pairs: 'btc_rur', limit: 20
#   puts trades 

#####   Testing Trade API   #####
#  puts "-----    getInfo   -----"
#  puts account_info

#  puts "-----    ActiveOrders   -----"
#  puts active_orders 'mode' => 'emulator'
#  puts active_orders
#  puts active_orders "pair" => 'btc_rur'

#  puts "-----    ActiveOrders   -----"
#  puts order_info 343152, 'mode' => 'emulator'

#  puts "-----    Trade (create orders)  -----"
#  puts trade pair: 'btc_usd', type: 'buy', rate: 8000.0, amount: 0.01

#  puts "-----    Cancel Order  -----"
#  puts cancel_order order_id: 343152
end
