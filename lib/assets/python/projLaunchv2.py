import pandas_ta as ta
import time
import datetime
import pandas as pd
import psycopg2
import ccxt
from pytz import timezone


class Bot:
    def __init__(self, id, name, username, trade_symbol, short, status, pre_pnl, pnl, tc, won, wr, balance, amount_traded, traded_quantity, entry_price, time =1, ema=None, bb=None, rsi=None, sma=None, macd=None, sar=None, vwap=None):

        self.multiplier = 1
        self.id = id
        self.time = time
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

        self.pre_pnl = pre_pnl
        self.pnl = pnl
        self.trade_count = tc
        self.won = won
        self.win_rate = wr
        self.balance = balance
        self.amount_traded = amount_traded
        self.traded_quantity = traded_quantity
        self.entry_price = entry_price
        self.status = status


        #date = datetime.datetime.now(timezone('US/Eastern')).strftime("%Y-%m-%d %H:%M:%S")
        self.client = ccxt.phemex({
        'enableRateLimit':
        True,
        'apiKey':
        '354967b0-6ed3-4670-8fa2-bb20be3c8cec',
        'secret':
        '5EXZBeqShWFxnWwUKfX0JiIMiz_uKyEI6FSb5VseZfwyNzMxOWU3OS0zMjI3LTRiZTItYWFkNC04NTVjMmEzMTlkY2I'
        })
        self.timeframe = '1m'





    def run(self):
        conn = psycopg2.connect(host="ec2-107-22-238-112.compute-1.amazonaws.com",database="dc6377fv43hqsg",user="gugaorxvpghenc",password="8abe2f397231caeb7c67736ed32c1781b2d7eb536b0c898139ec298bc32190fe")
        cur = conn.cursor()
        
        print("We are running! \n Bot id:", self.id)
    
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

        is_candle_closed = True
        if is_candle_closed:
            print("Candle Closed!!!!", self.id, self.pnl, self.traded_quantity)
            history = self.client.fetch_ohlcv(self.trade_symbol[:-1].upper(), timeframe=self.timeframe, limit=2000)
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
            price_close = float(df.iloc[-1]['close'])

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
                sql = "UPDATE public.bot_outs SET amount_traded = {}, entry_price = {}, traded_qty={}, status={} WHERE bot_id = {} and time = {}".format(
                    self.amount_traded, self.entry_price, self.traded_quantity, self.status, self.id, self.time
                )
                cur.execute(sql)
                conn.commit()

            elif self.status == 0 and check_short(ta_values, self.active_TA,
                                                price_close) and self.short:
                print("SHORT!", self.id)
                self.amount_traded = self.balance * self.multiplier
                self.entry_price = price_close
                self.traded_quantity = float(self.amount_traded / price_close)
                self.status = -1
                sql = "UPDATE public.bot_outs SET amount_traded = {}, entry_price = {}, traded_qty={}, status={} WHERE bot_id = {} and time = {}".format(
                    self.amount_traded, self.entry_price, self.traded_quantity, self.status, self.id, self.time
                )
                cur.execute(sql)
                conn.commit()

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
                self.time += 1
                date = datetime.datetime.now(timezone('US/Eastern')).strftime("%Y-%m-%d %H:%M:%S")
                sql = "INSERT INTO public.bot_outs (bot_id, time, pnl, wr, tc, status, pre_pnl, won, balance, amount_traded, traded_qty, entry_price, created_at) VALUES ({}, {}, {}, {}, {}, 0, {}, {}, {}, {}, {}, 0, '{}')".format(
                self.id, self.time, self.pnl, self.win_rate, self.trade_count, self.pre_pnl, self.won, self.balance, self.amount_traded, self.traded_quantity, date)
                cur.execute(sql)
                conn.commit()

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
                self.time += 1
                date = datetime.datetime.now(timezone('US/Eastern')).strftime("%Y-%m-%d %H:%M:%S")
                sql = sql = "INSERT INTO public.bot_outs (bot_id, time, pnl, wr, tc, status, pre_pnl, won, balance, amount_traded, traded_qty, entry_price, created_at) VALUES ({}, {}, {}, {}, {}, 0, {}, {}, {}, {}, {}, 0, '{}')".format(
                self.id, self.time, self.pnl, self.win_rate, self.trade_count, self.pre_pnl, self.won, self.balance, self.amount_traded, self.traded_quantity, date)
                cur.execute(sql)
                conn.commit()

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
            sql = "UPDATE public.bot_outs SET pnl = {}, wr = {}, tc={} WHERE bot_id = {} and time = {}".format(
                round(self.pnl, 2), round(self.win_rate, 2), self.trade_count,
                self.id, self.time)
            cur.execute(sql)
            print("We just updated the database!", self.id, round(self.pnl, 2))
            print(sql)
            conn.commit()


def start():
    while True:
        #start = time.time()
        conn = psycopg2.connect(
            host="ec2-107-22-238-112.compute-1.amazonaws.com",
            database="dc6377fv43hqsg",
            user="gugaorxvpghenc",
            password=
            "8abe2f397231caeb7c67736ed32c1781b2d7eb536b0c898139ec298bc32190fe")

        cur = conn.cursor()
        cur.execute("SELECT * from public.bots")
        bot_list = [
        dict(line) for line in [
            zip([column[0] for column in cur.description], row)
            for row in cur.fetchall()
        ]
        ]

        for exec_bot in bot_list:
            cur.execute("SELECT * from public.bot_outs WHERE bot_id = {}".format(exec_bot['id']))
            res = cur.fetchall()
            if len(res) == 0:
                print("new bot!!!")
                date = datetime.datetime.now(timezone('US/Eastern')).strftime("%Y-%m-%d %H:%M:%S")
                sql = "INSERT INTO public.bot_outs (bot_id, time, pnl, wr, tc, status, pre_pnl, won, balance, amount_traded, traded_qty, entry_price, created_at) VALUES ({}, {}, 0, 0, 0, 0, 0, 100, 0, 0, 0, '{}')".format(exec_bot['id'], 1, date)
                cur.execute(sql)
                conn.commit()
            cur.execute("SELECT * from public.bot_outs where bot_id = {}".format(exec_bot['id']))
            bout = cur.fetchall()

            bout = [
                dict(line) for line in [
                zip([column[0] for column in cur.description], row)
                for row in cur.fetchall()
                ]
            ]
            bout = bout[-1]
            
            bot = Bot(exec_bot['id'], exec_bot['name'], exec_bot['username'],
                  exec_bot['symbol'], exec_bot['short'],bout['status'], bout['pre_pnl'], bout['pnl'], bout['tc'], bout['won'], bout['wr'], bout['balance'], 
                  bout['amount_traded'], bout['traded_qty'], bout['entry_price'], bout['time'], exec_bot['ema'],
                  exec_bot['bb'], exec_bot['rsi'], exec_bot['sma'],
                  exec_bot['macd'], exec_bot['sar'], exec_bot['vwap'])
            bot.run()
        time.sleep(60)


start()