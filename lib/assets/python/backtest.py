import ccxt
import pandas as pd
import datetime
from pytz import timezone
import time
import numpy as np
import pandas_ta as ta
import psycopg2


def checkLong(ema1, ema2, ema3, ema4):
  if ema1 >= ema2 >= ema3 >= ema4:
    return True
  return False


def checkShort(ema1, ema2, ema3, ema4):
  if ema1 <= ema2 <= ema3 <= ema4:
    return True
  return False


def checkExit(ema, high):
  if high >= ema:
    return True
  return True


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
while True:

  cur = conn.cursor()

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

  ema1 = df.ta.ema(length=9)
  ema2 = df.ta.ema(length=14)
  ema3 = df.ta.ema(length=21)
  ema4 = df.ta.ema(length=55)

  bb = df.ta.bbands(length=20, std=2)

  lower = bb['BBL_20_2.0']
  upper = bb['BBU_20_2.0']
  median = bb['BBM_20_2.0']

  status = 0
  won = 0
  tc = 0
  pnl = 0
  entry = 0
  timeBot = 0
  wr = 0

  for i in range(8, 1998):
    close = df['close'][i]
    high = df['high'][i]
    if status == 0:
      if checkLong(ema1[i], ema2[i], ema3[i], ema4[i]):
        status = 1
        quantity = 100 / close
        entry = close
      elif checkShort(ema1[i], ema2[i], ema3[i], ema4[i]):
        status = -1
        quantity = 100 / close
        entry = close
    elif status == 1:
      if not checkLong(ema1[i], ema2[i], ema3[i], ema4[i]):
        status = 0
        tc += 1
        profit = (close - entry) * quantity
        pnl += profit
        if profit > 0:
          won += 1
    elif status == -1:
      if not checkShort(ema1[i], ema2[i], ema3[i], ema4[i]):
        status = 0
        tc += 1
        profit = (entry - close) * quantity
        pnl += profit
        if profit > 0:
          won += 1
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
    if i % 50 == 0:
      sql = "UPDATE public.edu_outs SET pnl={}, wr={}, tc={} where time={} and edu_id=1".format(
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
