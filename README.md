# README

README with 

(1) the names and UNIs of all team members

1. Erik Hansen (eh2889), 
2. Dominic Lee (dal2193), 
3. Harold Castiaux (hjc2154)

(2) instructions to run and test your product.

To run the app, simply start the rails server in the root directory of the project. You must have a properly configured Ruby on Rails environment to run the app, as well as a Postgres database (please connect to your IDE or environment), and have run rake db:migrate.
The app will be available at localhost:3000.
To test, create a bot configuration and check if the bot is able to be seen in the list of bots, which can be done by clicking on the "Your Bots" link in the navigation bar.

(3) Links

1. [Heroku](https://comsw4152-trading-bot-app.herokuapp.com/)
2. [Github](https://github.com/domlee590/TradingBotApp)

(4) Additional comments

PLEASE view the current rough draft for the bot implementation, which has been created in Python (FIND IN lib/assets/python) . The intention is to convert this to Ruby eventually and integrate it more with the rest of the app. It is a proof of concept.

We tried to integrate the output in the following way, but couldn't get it working in time:

class BotRunController < ApplicationController

  def show
    name = "bob"
    ma1 = 1
    ma2 = 48
    short = "yes"

    @ins = name + " " + ma1.to_s + " " + ma2.to_s + " " + short
    @out = `python lib/assets/python/paperTrading.py "#{@ins}"`

  end
end

This would render in a view. This will likely be working next iteration.
