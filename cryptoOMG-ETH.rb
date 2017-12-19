require 'open-uri'
require 'json'
require 'csv'

def fetch
  liqui_response = open("https://api.liqui.io/api/3/depth/omg_eth?limit=10").read
  # quadrigacx_response = open('https://api.quadrigacx.com/public/orders?book=eth_btc&group=1').read
  poloniex_response = open('https://poloniex.com/public?command=returnOrderBook&currencyPair=ETH_OMG&depth=10').read

  liqui_response = JSON.parse(liqui_response)
  # quadrigacx_response = JSON.parse(quadrigacx_response)
  poloniex_response = JSON.parse(poloniex_response)

  if liqui_response["success"] == 0 || poloniex_response == nil
    sleep(rand(6..13))
    fetch
  else
    # puts liqui_response
    puts "working"
    liqui_sell = liqui_response["omg_eth"]["asks"][0]
    liqui_buy = liqui_response["omg_eth"]["bids"][0]

    # quadrigacx_sell = [(quadrigacx_response["sell"][0]["rate"]).to_f, (quadrigacx_response["sell"][0]["amount"]).to_f]
    # quadrigacx_buy = [(quadrigacx_response["buy"][0]["rate"]).to_f, (quadrigacx_response["buy"][0]["amount"]).to_f]

    poloniex_sell = [(poloniex_response["asks"][0][0]).to_f, poloniex_response["asks"][0][1]]
    poloniex_buy = [(poloniex_response["bids"][0][0]).to_f, poloniex_response["bids"][0][1]]

    top_trades = { sells:
      { sell_on_liqui: liqui_buy,
        # sell_on_quadrigacx: quadrigacx_buy,
        sell_on_poloniex: poloniex_buy },
        buys:
        { buy_on_liqui: liqui_sell,
          # buy_on_quadrigacx: quadrigacx_sell,
          buy_on_poloniex: poloniex_sell}
        }
  end
end
# figuring out the highest sell and lowest buy

def find_highest_sell(sells)
  (sells.max_by{|k,v| v})
end

def find_lowest_buy(buys)
  (buys.min_by{|k,v| v})
end

def profitable_trade(trades)
  counter = 0
  high_sell = find_highest_sell(trades[:sells])
  low_buy = find_lowest_buy(trades[:buys])
  puts high_sell[1][0] - (low_buy[1][0] * ((1 + 0.0025)/ ( 1 - 0.0026)) + (0.005+0.3*low_buy[1][0])/96)
  if high_sell[1][0] >= (low_buy[1][0] * ((1 + 0.0025)/ ( 1 - 0.0026)) + (0.005+0.3*low_buy[1][0])/96)
    find_highest_amount([high_sell, low_buy])
  end
end

def clock
  trades = fetch()
  profitable_trade(trades)
  sleep(rand(8..13))
  clock
end

def find_highest_amount(data)
  # data is in a format of [sellexchange: [rate, omg_amount], buyexchang: [rate, omg_amount]]
  if (data[0][1][1] < data[1][1][1])
    write_to_csv([ data[0][0], data[0][1][0], data[1][0], data[1][1][0], data[0][1][1], Time.now ])
  else
    write_to_csv( [ data[0][0], data[0][1][0], data[1][0], data[1][1][0], data[1][1][1], Time.now] )
  end
end

def write_to_csv(data)
  CSV.open('profitsOMG-ETH.csv', 'a+') do |csv|
    csv << data
  end
end
clock()
