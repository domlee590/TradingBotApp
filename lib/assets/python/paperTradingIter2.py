import websocket, json
import pandas_ta as ta
import time
import datetime
import pandas as pd
from binance.enums import *
from binance.client import Client as ClientReal
import psycopg2
import os
"""
Quick description:
This script scans the database all the time to see if a new bot was added
Then initializes its outputs and updates them every 1 minute. 
The bot checks for a trade signal every minute taking into account the settings given by the user
There is a start function that keeps checking for new bots and forks when it finds one. 
There is a Bot class that initializes the bot with the data stored in our database. 
Bot has a run method that enables it to keep checking for trade signals using check_long and check_short. 
The run method continuously updates the instances of the class Bot and updates the database. 

Challenges:
We need to read from the database but then also act on the database to insert and modify it.
We fork everytime there is a new bot and run it all in parallel.
We need to make sure we keep track of the bots already running and the ones not running yet.
We have 3 different tables in the database - users, bots and bot_outputs - that all interact with each other. 
"""

class Bot:

  def __init__(self,
               id,
               name,
               username,
               trade_symbol,
               short,
               ema=None,
               bb=None,
               rsi=None,
               sma=None,
               macd=None,
               sar=None,
               vwap=None):
    conn = psycopg2.connect(
      host="ec2-52-21-136-176.compute-1.amazonaws.com",
      database="d227oe4urq27dt",
      user="nhsgqktdsneswv",
      password=
      "490c9ae5e972835ac50956a10fc9641b59002bedaf1ca7bea0c8116e293f1c76")

    cur = conn.cursor()
    self.id = id
    self.name = name
    self.username = username
    self.trade_symbol = trade_symbol
    self.short = short
    self.active_TA = []
    self.active_TA_values = []
    # Technical Indicators
    if ema:
      self.ema = ema
      self.active_TA.append("ema_value")
      self.active_TA_values.append(ema)
    else:
      self.ema = None
    if bb:
      self.bb = bb
      self.active_TA.append("bb_value")
      self.active_TA_values.append(bb)
    else:
      self.bb = None
    if rsi:
      self.rsi = rsi
      self.active_TA.append("rsi_value")
      self.active_TA_values.append(rsi)
    else:
      self.rsi = None
    if sma:
      self.sma = sma
      self.active_TA.append("sma_value")
      self.active_TA_values.append(sma)
    else:
      self.sma = None
    if macd:
      self.macd = macd
      self.active_TA.append("macd_value")
      self.active_TA_values.append(macd)
    else:
      self.macd = None
    if sar:
      self.sar = sar
      self.active_TA.append("sar_value")
      self.active_TA_values.append(sar)
    else:
      self.sar = None
    if vwap:
      self.vwap = vwap
      self.active_TA.append("vwap_value")
      self.active_TA_values.append(vwap)
    else:
      self.vwap = None
    # General Data
    if len(self.active_TA) == 0:
      self.ema = 55
      self.active_TA.append("ema_value")
      self.active_TA_values.append(55)
      
    self.pre_pnl = 0
    self.pnl = 0
    self.trade_count = 0
    self.won = 0
    self.win_rate = 0
    self.balance = 100
    self.multiplier = 1
    self.amount_traded = 0
    self.traded_quantity = 0
    self.entry_price = 0
    self.status = 0  # 0, 1 (Long), -1 (Short)
    self.description = "Hi, I am {}! Nice to meet you! Here is your strategy: \n".format(
      self.name)
    for i in range(len(self.active_TA)):
      self.description += (self.active_TA[i][:-6] + ": " +
                           str(self.active_TA_values[i]) + "\n")

    self.description += ("short: " + str(self.short) + "\n")
    self.description += "It is running on: {}.".format(self.trade_symbol)
    sql = "INSERT INTO public.bot_outputs (bot_id, description, pnl, wr, tc) VALUES ({}, '{}', 0, 0, 0)".format(
      self.id, self.description)
    cur.execute(sql)
    conn.commit()
    conn.close()
    cur.close()
    self.client = ClientReal(
      "u5zK5XVJ29IQwoQ1Sy5Ojc4Yjrr7ipGyQynlad1Z4a81vSh2roR8TzVksuIFQhPI",
      "a4jyjiysyvE3ZzuvnuI3dBHIqmQ7W3KQH4JMNdBIpLDwzGiRl23k2qw2Qtjwzzlz")
    self.socket = "wss://fstream.binance.com/ws/{}_perpetual@continuousKline_1m".format(
      self.trade_symbol.lower())

  def run(self):
    conn = psycopg2.connect(
      host="ec2-52-21-136-176.compute-1.amazonaws.com",
      database="d227oe4urq27dt",
      user="nhsgqktdsneswv",
      password=
      "490c9ae5e972835ac50956a10fc9641b59002bedaf1ca7bea0c8116e293f1c76")

    cur = conn.cursor()
    print("We are running! \n Bot id:", self.id)
    while True:

      def on_open(ws):
        print("Connection Successful", self.id)

      def on_close(ws):
        print("Connection Closed")

      def check_long(dict, ta_list, price):
        easy_group = ["ema_value", "sma_value", "vwap_value"]
        for key in ta_list:
          if key in easy_group:
            if price < dict[key]:
              return False
          elif key == "rsi_value":
            if dict[key] > 30:
              return False
          elif key == "bb_value":
            range = (dict[key][0] - dict[key][1]) * 0.10
            if not (price < dict[key][1] + range):
              return False
          elif key == "macd_value":
            if dict[key][0] > dict[key][1]:
              return False
          elif key == "sar_value":
            if dict[key][1] > 0:
              return False

        return True

      def check_short(dict, ta_list, price):
        easy_group = ["ema_value", "sma_value", "vwap_value"]
        for key in ta_list:
          if key in easy_group:
            if price > dict[key]:
              return False
          elif key == "rsi_value":
            if dict[key] < 70:
              return False
          elif key == "bb_value":
            range = (dict[key][0] - dict[key][1]) * 0.10
            if not (price > dict[key][0] - range):
              return False
          elif key == "macd_value":
            if dict[key][0] < dict[key][1]:
              return False
          elif key == "sar_value":
            if dict[key][0] > 0:
              return False

        return True

      def on_message(ws, message):
        received_message = json.loads(message)
        candle = received_message['k']
        is_candle_closed = candle['x']
        #is_candle_closed = True
        if is_candle_closed:
          print("Candle Closed!!!!", self.id, self.pnl, self.traded_quantity)
          history = self.client.futures_klines(
            symbol=self.trade_symbol,
            interval=self.client.KLINE_INTERVAL_1MINUTE,
            limit=1500)
          df = pd.DataFrame(history).iloc[:, :6]
          df = df.apply(pd.to_numeric)
          df = df.rename(columns={
            0: 'time',
            1: 'open',
            2: 'high',
            3: 'low',
            4: 'close',
            5: 'volume'
          })
          price_close = float(candle['c'])

          ta_values = {}
          ta_values["ema_value"] = df.ta.ema(length=self.ema)[1499]
          if self.bb:
            bbl = df.ta.bbands(length=self.bb,
                               std=2)['BBL_{}_2.0'.format(self.bb)][1499]
            bbu = df.ta.bbands(length=self.bb,
                               std=2)['BBU_{}_2.0'.format(self.bb)][1499]
            ta_values["bb_value"] = [bbu, bbl]

          ta_values["rsi_value"] = df.ta.rsi()[1499]
          ta_values["sma_value"] = df.ta.sma(length=self.sma)[1499]

          #mac = df.ta.macd()
          ta_values["macd_value"] = [
            df.ta.macd()["MACDs_12_26_9"][1499],
            df.ta.macd()["MACD_12_26_9"][1499]
          ]
          sar = df.ta.psar()
          ta_values["sar_value"] = [
            sar['PSARl_0.02_0.2'][1499], sar['PSARs_0.02_0.2'][1499]
          ]
          #df = df.set_index(pd.DatetimeIndex(df["datetime"]), inplace=True)
          ta_values["vwap_value"] = df.ta.vwma(length=self.vwap)[1499]

          if self.status == 0 and check_long(ta_values, self.active_TA,
                                             price_close):
            print("LONG!", self.id)
            self.amount_traded = self.balance * self.multiplier
            self.entry_price = price_close
            self.traded_quantity = float(self.amount_traded / price_close)
            self.status = 1

          elif self.status == 0 and check_short(ta_values, self.active_TA,
                                                price_close) and self.short:
            print("SHORT!", self.id)
            self.amount_traded = self.balance * self.multiplier
            self.entry_price = price_close
            self.traded_quantity = float(self.amount_traded / price_close)
            self.status = -1

          elif self.status == 1 and not check_long(ta_values, self.active_TA,
                                                   price_close):
            print("Close Position! Long.", self.id)
            self.status = 0
            self.trade_count += 1
            profit = (price_close - self.entry_price) * self.traded_quantity
            if profit > 0:
              self.won += 1
            self.win_rate = self.won / self.trade_count
            self.balance = (self.amount_traded / self.multiplier) + profit
            self.amount_traded = 0
            self.traded_quantity = 0
            self.pre_pnl += profit
            self.pnl = self.pre_pnl

          elif self.status == -1 and not check_short(ta_values, self.active_TA,
                                                     price_close):
            print("Close Position! Short.", self.id)
            self.status = 0
            self.trade_count += 1
            profit = (self.entry_price - price_close) * self.traded_quantity
            if profit > 0:
              self.won += 1
            self.win_rate = self.won / self.trade_count
            self.balance = (self.amount_traded / self.multiplier) + profit
            self.amount_traded = 0
            self.traded_quantity = 0
            self.pre_pnl += profit
            self.pnl = self.pre_pnl

          else:
            print("We don't move", self.id)
            if self.status == 1:
              profit = (price_close - self.entry_price) * self.traded_quantity
              self.balance = (self.amount_traded / self.multiplier) + profit
              self.pnl = self.pre_pnl + profit
            elif self.status == -1:
              profit = (self.entry_price - price_close) * self.traded_quantity
              self.balance = (self.amount_traded / self.multiplier) + profit
              self.pnl = self.pre_pnl + profit
          sql = "UPDATE public.bot_outputs SET pnl = {}, wr = {}, tc={} WHERE bot_id = {}".format(
            round(self.pnl, 2), round(self.win_rate, 2), self.trade_count,
            self.id)
          cur.execute(sql)
          print("We just updated the database!", self.id, round(self.pnl, 2),
                self.pnl)
          print(sql)
          conn.commit()
        #print("Bot Number:", self.id, "PNL:", self.pnl, "Number of Trades:", self.trade_count, "Win Rate:", self.win_rate, "Balance:", self.balance)

      # Run the websocket forever
      ws = websocket.WebSocketApp(self.socket,
                                  on_open=on_open,
                                  on_close=on_close,
                                  on_message=on_message)
      ws.run_forever()

def start():
  while True:
    conn = psycopg2.connect(
      host="ec2-52-21-136-176.compute-1.amazonaws.com",
      database="d227oe4urq27dt",
      user="nhsgqktdsneswv",
      password=
      "490c9ae5e972835ac50956a10fc9641b59002bedaf1ca7bea0c8116e293f1c76")

    cur = conn.cursor()
    cur.execute("SELECT * from public.bots")
    bot_list = [
      dict(line) for line in [
        zip([column[0] for column in cur.description], row)
        for row in cur.fetchall()
      ]
    ]

    not_started_bots = []

    for exec_bot in bot_list:
      cur.execute("SELECT * from public.bot_outputs WHERE bot_id = {}".format(
        exec_bot['id']))
      res = cur.fetchall()
      if len(res) == 0:
        print("not in")
        not_started_bots.append(exec_bot)
    for exec_bot in not_started_bots:
      rc = os.fork()
      if rc != 0:
        # FORK!
        # Bot was just initialized, let's run it.
        bot = Bot(exec_bot['id'], exec_bot['name'], exec_bot['username'],
                  exec_bot['symbol'], exec_bot['short'], exec_bot['ema'],
                  exec_bot['bb'], exec_bot['rsi'], exec_bot['sma'],
                  exec_bot['macd'], exec_bot['sar'], exec_bot['vwap'])
        conn.close()
        cur.close()
        bot.run()
        return 1


start()
