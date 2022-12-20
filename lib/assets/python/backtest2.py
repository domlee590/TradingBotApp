"""

https://www.youtube.com/watch?v=Yj0yEBxwLVw&t=146s
Strategy: Get MACD, Get 200 EMA. 
If MACD crosses down and price below EMA -> go short, SL at EMA and TP at 1.5x
Opposite for Long

"""

import ccxt
import pandas as pd
import datetime
from pytz import timezone
import time
import numpy as np
import pandas_ta as ta
import psycopg2


def checkLong(ema, macd_diff, price):
  if ema <= price and macd_diff >= 0:
    return True
  return False


def checkShort(ema, macd_diff, price):
  if ema >= price and macd_diff <= 0:
    return True
  return False


phemex = ccxt.phemex({
  'enableRateLimit':
  True,
  'apiKey':
  '354967b0-6ed3-4670-8fa2-bb20be3c8cec',
  'secret':
  '5EXZBeqShWFxnWwUKfX0JiIMiz_uKyEI6FSb5VseZfwyNzMxOWU3OS0zMjI3LTRiZTItYWFkNC04NTVjMmEzMTlkY2I'
})

symbol = 'ETHUSD'
timeframe = '30m'
limit = 2000
conn = psycopg2.connect(
  host="ec2-107-22-238-112.compute-1.amazonaws.com",
  database="dc6377fv43hqsg",
  user="gugaorxvpghenc",
  password="8abe2f397231caeb7c67736ed32c1781b2d7eb536b0c898139ec298bc32190fe")

tsc = round(time.time()) * 1000


def getLast10k(ts):
  df_total = pd.DataFrame()
  i = 5
  while i > 0:
    if i == 5:
      start = ts - (i * 2000 * 1000 * 60)
    bars = phemex.fetch_ohlcv(symbol,
                              timeframe=timeframe,
                              since=start,
                              limit=2000)

    df = pd.DataFrame(
      bars, columns=['timestamp', 'open', 'high', 'low', 'close', 'volume'])

    df_first = df.loc[:, ['timestamp', 'open', 'high', 'low', 'close']]
    df = df_first.rename(columns={
      0: 'time',
      1: 'open',
      2: 'high',
      3: 'low',
      4: 'close'
    })
    df = df.apply(pd.to_numeric)
    if i != 1:
      start = df.iloc[-1]['timestamp'] + (1 * 60 * 1000)
    frames = [df_total, df]
    df_total = pd.concat(frames)
    i -= 1

  return df_total


#df = getLast10k(tsc)

bars = phemex.fetch_ohlcv(symbol, timeframe=timeframe, limit=2000)
df = pd.DataFrame(
  bars, columns=['timestamp', 'open', 'high', 'low', 'close', 'volume'])

df_first = df.loc[:, ['timestamp', 'open', 'high', 'low', 'close']]
df = df_first.rename(columns={
  0: 'time',
  1: 'open',
  2: 'high',
  3: 'low',
  4: 'close'
})
df = df.apply(pd.to_numeric)

while True:

  cur = conn.cursor()

  ema = df.ta.ema(length=200)

  macd = df.ta.macd()
  macd_diff = macd['MACDh_12_26_9']

  status = 0
  won = 0
  tc = 0
  pnl = 0
  entry = 0
  timeBot = 0
  wr = 0

  for i in range(33, 1998):
    close = df['close'][i]
    high = df['high'][i]
    low = df['low'][i]
    if status == 0:
      if checkLong(ema[i], macd_diff[i], close):
        status = 1
        quantity = 100 / close
        entry = close
        sl = ema[i]
        tp = entry + ((entry - sl) * 1.5)
        continue
      elif checkShort(ema[i], macd_diff[i], close):
        status = -1
        quantity = 100 / close
        entry = close
        sl = ema[i]
        tp = entry - ((sl - entry) * 1.5)
        continue

    elif status == 1:
      if low <= sl:
        status = 0
        tc += 1
        profit = (sl - entry) * quantity
        pnl += profit
        if profit > 0:
          won += 1
        continue
      elif high >= tp:
        status = 0
        tc += 1
        profit = (tp - entry) * quantity
        pnl += profit
        if profit > 0:
          won += 1
        continue

    elif status == -1:

      if high >= sl:
        status = 0
        tc += 1
        profit = (entry - sl) * quantity
        pnl += profit
        if profit > 0:
          won += 1
        continue
      elif low <= tp:
        status = 0
        tc += 1
        profit = (entry - tp) * quantity
        pnl += profit
        if profit > 0:
          won += 1
        continue

    if i == 1997 and status == 1:
      tc += 1
      profit = (close - entry) * quantity
      pnl += profit
      if profit > 0:
        won += 1
    elif i == 1997 and status == -1:
      tc += 1
      profit = (entry - close) * quantity
      pnl += profit
      if profit > 0:
        won += 1

    if tc != 0:
      wr = (won / tc) * 100
    if i % 49 == 0:
      sql = "UPDATE public.edu_outs SET pnl={}, wr={}, tc={} where time={} and edu_id=2".format(
        round(pnl, 2), round(wr, 2), tc, timeBot)
      print(sql)
      timeBot += 1
      cur.execute(sql)
      conn.commit()
      print("Win Rate:", round(wr, 2))
      print("Number of trades:", tc)
      print("PNL:", round(pnl, 3))
      print("Time:", timeBot)

  time.sleep(2000)
