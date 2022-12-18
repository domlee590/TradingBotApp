(1) Team members
1. Erik Hansen (eh2889),
2. Dominic Lee (dal2193),
3. Harold Castiaux (hjc2154)

(2) Instructions

Go ahead and sign up if you haven't created an account or login if you have.
Once you are logged in you will see all the bots you have created already.
If you don't see any bot, go ahead and create a new bot.
Input all the values you want your bot to take into consideration.
(it is recommended but not required to not input too many technical indicators for the performance of your bot.)
Don't forget to give it a name
Once the bot is created go ahead and click on more details to see its settings as well as its current performance.
Three indicators are used to keep track of your bot's performance:
- PNL (Profit net loss) in %: The higher the better.
- Win Rate: What fraction of the trades did your bot won (value between 0 and 1)
- Trade Count: The amount of trades your bot has done
The PNL is updated in real time every one minute, just refresh your page to see the updated amount.
The Win Rate and Trade Count get updated when a trade is closed.
If you don't like your bot, you can just delete it and create a new one.

The Python script is currently configured to run exclusively on the Replit platform while 
connected to the Heroku database. IT IS LOCATED IN /lib/assets/python/paperTradingIter2.py, VIEW IF YOU WISH.
It can be configured to run on any platform as long as the modules are properly installed and the database credentials are updated to 
whatever the app itself is using. For example if you are using a local database and 
running the script locally, you will need to update the database credentials to match your localhost.


(3) Links

1. [Heroku](https://comsw4152-trading-bot-app.herokuapp.com/)
2. [Github](https://github.com/domlee590/TradingBotApp)

(4) Additional comments

We had to use python for this project to be able to use the python-binance library that is not extensively developed on ruby.
You can checkout the python script that is running 24/7 on a server in the github repo above.
This script is what enables us to update the PNL, win rate and trade count.
There is a constant communication between our web app, our database and our python script.
Ruby App <-> Postgres Database on Heroku <-> Python script. The Heroku database credentials are apparently subject to change, 
therefore the Python script must be updated periodically with the new credentials.

We aim to add the backtesting functionality for the Youtube videos for the Final Submission as well as minor improvements
such as adding a change password functionality and more flexibility in the bot configuration.