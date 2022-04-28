module Face
  def self.trade_emulator method, options = {}
    
    case method
    when 'ActiveOrders'
      return  {
        "success" => 1,
        "return"  => {
          "343152" => {
            "pair"              => "btc_usd",
            "type"              => "sell",
            "amount"            => 1.345,
            "rate"              => 2590.5,
            "timestamp_created" => (Time.now-7200).to_i,
            "status"            => 0
          },                
          "412512" => {
            "pair"              => "btc_rur",
            "type"              => "buy",
            "amount"            => 0.052,
            "rate"              => 157339.88776,
            "timestamp_created" => (Time.now-4300).to_i,
            "status"            => 0
          },
          "487539" => {
            "pair"              => "btc_eur",
            "type"              => "buy",
            "amount"            => 1.02,
            "rate"              => 2301.47372,
            "timestamp_created" => (Time.now-1800).to_i,
            "status"            => 0
          },
        }
      }
      
    when 'OrderInfo'
      return  {
        "success" => 1,
        "return"  => {
          "343152" => {
            "pair"              => "btc_usd",
            "type"              => "sell",
            "start_amount"      => 1.5,
            "amount"            => 1.345,
            "rate"              => 2590.5,
            "timestamp_created" => (Time.now-7200).to_i,
            "status"            => 3
          },
        }
      }
    end
  end
end
