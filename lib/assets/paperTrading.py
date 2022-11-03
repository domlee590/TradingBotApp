import websocket, json
import pandas_ta as ta
import datetime
import pandas as pd
from binance.enums import *
from binance.client import Client as ClientReal
import sys

n = sys.argv[1]
ma1Arg = sys.argv[2]
ma2Arg = sys.argv[3]
s = sys.argv[4]

clientreal = ClientReal("u5zK5XVJ29IQwoQ1Sy5Ojc4Yjrr7ipGyQynlad1Z4a81vSh2roR8TzVksuIFQhPI", "a4jyjiysyvE3ZzuvnuI3dBHIqmQ7W3KQH4JMNdBIpLDwzGiRl23k2qw2Qtjwzzlz")

socket = "wss://fstream.binance.com/ws/ethusdt_perpetual@continuousKline_1m"
name = n
short = s
moving_avg1 = ma1Arg
moving_avg2 = ma2Arg
number_of_trades = 0
trade_symbol = "ETHUSDT"
status = 0                                  # 0 = not in a trade, 1 = longing, -1 = shorting
balance = 100
pnl = 0

print("Hi, I am {}, nice to meet you! Let's start Trading!".format(name))


while True:

def on_open(ws):
  print("")

def on_close(ws):
  print("closed connection")

def check_short(ma1, ma2):
  return ma1 < ma2

def check_long(ma1, ma2):
  return ma1 > ma2

def get_traded_quantity(amount_traded, price):
  return float(amount_traded / price)

def on_message(ws, message):
  nonlocal balance
  nonlocal pnl
  nonlocal trade_symbol
  nonlocal number_of_trades
  nonlocal status
  received_message = json.loads(message)
  candle = received_message['k']
  is_candle_closed = candle['x']
  close = float(candle['c'])

  amount_traded = 100

  if is_candle_closed:
    print("\n----------------------------------------------------")
    print('                           TIME', datetime.datetime.now().strftime("%H:%M"))
    print("candle closed at {}".format(close))
    print("Number of trades:", number_of_trades)
    print("PNL:", pnl, "%")

    candles = clientreal.futures_klines(symbol=trade_symbol,
                    interval=clientreal.KLINE_INTERVAL_1MINUTE,
                    limit=1500)
    df = pd.DataFrame(candles).iloc[:, : 6]
    df = df.rename(columns={0 :'time', 1 : 'open', 2 : 'high', 3 : 'low', 4: 'close', 5: 'volume'})
    df = df.apply(pd.to_numeric)
    ma1 = df.ta.sma(length=min(moving_avg1, moving_avg2))
    ma1 = ma1[len(ma1) - 1]
    ma2 = df.ta.sma(length=max(moving_avg1, moving_avg2))
    ma2 = ma2[len(ma2) - 1]

    if status == 0:
      #print(ma1, ma2, short, check_short(ma1, ma2), check_long(ma1, ma2))
      if short == "yes" and check_short(ma1, ma2):
        print("Short!")
        status = -1
        traded_quantity = get_traded_quantity(amount_traded, df['close'][len(df.index) - 1])
      else:
        if check_long(ma1, ma2):
          print("Long!")
          status = 1
          traded_quantity = get_traded_quantity(amount_traded, df['close'][len(df.index) - 1])

    elif status == 1:
      print("We are going long")
      if check_short(ma1, ma2):
        status = 0
        cash_back = traded_quantity * df['close'][len(df.index) - 1]
        balance += cash_back
        number_of_trades += 1
        pnl += (cash_back / 100)
    elif status == -1:
      print("We are going short")
      if check_long(ma1, ma2):
        status = 0
        cash_back = traded_quantity * df['close'][len(df.index) - 1]
        balance -= cash_back
        number_of_trades += 1
        pnl -= (cash_back / 100)






ws = websocket.WebSocketApp(socket, on_open= on_open, on_close=on_close, on_message=on_message)

ws.run_forever()
