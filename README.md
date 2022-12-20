(1) Team members
1. Erik Hansen (eh2889),
2. Dominic Lee (dal2193),
3. Harold Castiaux (hjc2154)

(2) Instructions

Go ahead and sign up if you haven't created an account or login if you have.
Once you are logged in you will see all the bots you have created already.
If you don't see any bot, go ahead and create a new bot.
Input all the values you want your bot to take into consideration.
If you have no experience on how trading bots work, there is a youtube video demonstrating how the create bot works.
(it is recommended but not required to not input too many technical indicators for the performance of your bot.)
Don't forget to give it a name
Once the bot is created go ahead and click on more details to see its settings as well as its current performance.
Three indicators are used to keep track of your bot's performance:
- PNL (Profit net loss) in %: The higher the better.
- Win Rate: What fraction of the trades did your bot win (value between 0 and 1)
- Trade Count: The amount of trades your bot has done
  The PNL is updated in real time every one minute, just refresh your page to see the updated amount.
  The Win Rate and Trade Count get updated when a trade is closed.
  If you don't like your bot, you can edit it in real time.
  There is a new graph functionality to shows you the evolution of your pnl, win rate and trade count over the last 5 trades.

The Python scripts are currently configured to run exclusively on the Replit platform while
connected to the Heroku database. THEY ARE LOCATED IN /lib/assets/python, VIEW IF YOU WISH.
It can be configured to run on any platform as long as the modules are properly installed and the database credentials are updated to
whatever the app itself is using. For example if you are using a local database and
running the script locally, you will need to update the database credentials to match your localhost.


There are three main scripts: One for the live trading functionality and two for the backtesting.
These scripts use the ccxt library in order to get the LIVE price data from the token of your choice.
They also use pandas-ta to get accurate technical indicators.
They read and write to the database constantly.


(3) Links

1. [Heroku](https://comsw4152-trading-bot-app.herokuapp.com/)
2. [Github](https://github.com/domlee590/TradingBotApp)

(4) Additional comments

We had to use python for this project to be able to use the ccxt library that is not extensively developed on ruby.
You can check out the python script that is running 24/7 on a server in the github repo above.
This script is what enables us to update the PNL, win rate and trade count and more importantly get real price data live.
There is constant communication between our web app, our database and our python script.
Ruby App <-> Postgres Database on Heroku <-> Python script.
The Heroku database credentials are apparently subject to change, therefore the Python script must be updated
periodically with the new credentials.

We listened to the feedback and added an "edit bot" functionality as well as an ever more clear video explanation on how to create
a bot and use our application.
As promised, we added the backtesting functionality for two very famous videos that promise you wonders.

We also took time to improve the aesthetics of our website.