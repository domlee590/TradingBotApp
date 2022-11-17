class BotsController < ApplicationController

  def new
    # default: render 'new' template
  end

  def index
    currentUserID = session[:user_id]
    currentUsername = User.find(currentUserID).username

    @bots = Bot.where(username: currentUsername)
  end

  def create
    currentUserID = session[:user_id]
    currentUsername = User.find(currentUserID).username

    data = bot_params
    data[:username] = currentUsername

    @bot = Bot.create!(data)
    flash[:alert] = "#{@bot.name} was successfully created."
    redirect_to bots_path
  end

  def show
    id = params[:id] # retrieve bot ID from URI route
    @bot = Bot.find(id) # look up bot by unique ID
    @bot_output = BotOutput.where(bot_id: id).first
  end

  def destroy
    @bot = Bot.find(params[:format])
    @bot_output = BotOutput.where(bot_id: params[:format]).first
    @bot_output.destroy
    @bot.destroy
    flash[:notice] = "Bot '#{@bot.name}' deleted."
    redirect_to bots_path
  end

  private
  def bot_params
    params.require(:bot).permit(:name, :ema, :bb, :rsi, :sma, :macd, :sar, :vwap, :symbol, :short, :username)
  end
end


