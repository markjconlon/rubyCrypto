require 'open-uri'
require 'json'

liqui_response = open("https://api.liqui.io/api/3/depth/eth_btc?limit=10").read
quadrigacx_response = open('https://api.quadrigacx.com/public/orders?book=eth_btc&group=1').read
poloniex_response = open('https://poloniex.com/public?command=returnOrderBook&currencyPair=BTC_ETH&depth=10').read

liqui_response = JSON.parse(liqui_response)
quadrigacx_response = JSON.parse(quadrigacx_response)
poloniex_response = JSON.parse(poloniex_response)

liqui_sell = liqui_response["eth_btc"]["asks"][0]
liqui_buy = liqui_response["eth_btc"]["bids"][0]

quadrigacx_sell = [(quadrigacx_response["sell"][0]["rate"]).to_f, (quadrigacx_response["sell"][0]["amount"]).to_f]
quadrigacx_buy = [(quadrigacx_response["buy"][0]["rate"]).to_f, (quadrigacx_response["buy"][0]["amount"]).to_f]

poloniex_sell = [(poloniex_response["asks"][0][0]).to_f, poloniex_response["asks"][0][1]]
poloniex_buy = [(poloniex_response["bids"][0][0]).to_f, poloniex_response["bids"][0][1]]

top_trades = { sells:
                { sell_on_liqui: liqui_buy,
                  sell_on_quadrigacx: quadrigacx_buy,
                  sell_on_poloniex: poloniex_buy },
               buys:
                { buy_on_liqui: liqui_sell,
                  buy_on_quadrigacx: quadrigacx_sell,
                  buy_on_poloniex: poloniex_sell}
             }

# figuring out the highest sell and lowest buy

def find_highest_sell(sells)
  (sells.max_by{|k,v| v})
end

def find_lowest_buy(buys)
  (buys.min_by{|k,v| v})
end

def profitable_trade(trades)
  high_sell = find_highest_sell(trades[:sells])
  low_buy = find_lowest_buy(trades[:buys])
  if high_sell[1][0] >= ((low_buy[1][0] / (0.9975 * 0.9974)) + 0.0001 )
    return [high_sell, low_buy]
  else
    return  [low_buy[1][0], high_sell[1][0], ((low_buy[1][0] / (0.9975 * 0.9974)) + 0.0001)]
  end
end
puts profitable_trade(top_trades)
