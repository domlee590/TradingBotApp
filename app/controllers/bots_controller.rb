class BotsController < ApplicationController
  skip_before_action :authorized
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
    flash[:notice] = "#{@bot.name} was successfully created."
    redirect_to bots_path
  end

  def show
    id = params[:id] # retrieve bot ID from URI route
    @bot = Bot.find(id) # look up bot by unique ID

    if @bot.username != User.find(session[:user_id]).username
      flash[:alert] = "Cannot view this bot as #{User.find(session[:user_id]).username}"
      redirect_to bots_path
    else
      @bot_output = BotOut.where(bot_id: id).last

      bot_output_raw = BotOut.where(bot_id: id)

      @chart_data_pnl = []
      @chart_data_wr = []
      @chart_data_tc = []
      bot_output_raw.each do |bot_output|
        @chart_data_pnl << [bot_output.created_at, bot_output.pnl]
        @chart_data_wr << [bot_output.created_at, bot_output.wr]
        @chart_data_tc << [bot_output.created_at, bot_output.tc]
      end
    end

  end

  def destroy
    @bot = Bot.find(params[:format])

    if @bot.username != User.find(session[:user_id]).username
      flash[:alert] = "Cannot delete this bot as #{User.find(session[:user_id]).username}"
      redirect_to bots_path
    else
      @bot_output = BotOutput.where(bot_id: params[:format]).first

      unless @bot_output.nil?
        @bot_output.destroy
      end

      @bot.destroy
      flash[:notice] = "Bot '#{@bot.name}' deleted."
      redirect_to bots_path
    end
  end

  private
  def bot_params
    params.require(:bot).permit(:name, :ema, :bb, :rsi, :sma, :macd, :sar, :vwap, :symbol, :short, :username)
  end
end


