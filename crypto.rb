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

quadrigacx_sell = [quadrigacx_response["sell"][0]["rate"], quadrigacx_response["sell"][0]["amount"]]
quadrigacx_buy = [quadrigacx_response["buy"][0]["rate"], quadrigacx_response["buy"][0]["amount"]]

poloniex_sell = poloniex_response["asks"][0]
poloniex_buy = poloniex_response["bids"][0]
top_trades = {sell_on_liqui: liqui_buy, buy_on_liqui: liqui_sell,
              sell_on_quadrigacx: quadrigacx_buy, buy_on_quadrigacx: quadrigacx_sell,
              sell_on_poloniex: poloniex_buy, buy_on_poloniex: poloniex_sell}
puts top_trades
