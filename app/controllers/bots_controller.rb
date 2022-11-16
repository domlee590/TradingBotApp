class BotsController < ApplicationController

  def new
    # default: render 'new' template
  end

  def index
    @bots = Bot.all_bots
  end

  def create
    currentUserID = session[:user_id]
    currentUsername = User.find(currentUserID).username

    bot_params[:username] = currentUsername

    @bot = Bot.create!(bot_params)
    flash[:notice] = "#{@bot.name} was successfully created."
    redirect_to bots_path
  end

  def edit
    @bot = Bot.find params[:id]
  end

  def update
    @bot = Bot.find params[:id]
    @bot.update!(bot_params)
    flash[:notice] = "#{@bot.name} was successfully updated."
    redirect_to bot_path(@bot)
  end


  def show
    id = params[:id] # retrieve movie ID from URI route
    @bot = Bot.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  private
  def bot_params
    params.require(:bot).permit(:name, :ema, :bb, :rsi, :sma, :macd, :sar, :vwap, :symbol, :short)
  end
end


