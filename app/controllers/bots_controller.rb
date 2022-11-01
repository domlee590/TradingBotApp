class BotsController < ApplicationController

  def new
    # default: render 'new' template
  end

  def index
    @bots = Bot.all_movies
  end

  def create
    @bot = Bot.create!(bot_params)
    flash[:notice] = "#{@bot.name} was successfully created."
    redirect_to bots_path
  end

  def edit
    @bot = Bot.find params[:id]
  end

  def update
    @bot = Bot.find params[:id]
    @bot.update_attributes!(bot_params)
    flash[:notice] = "#{@bot.title} was successfully updated."
    redirect_to bot_path(@bot)
  end

  def destroy
    @bot = Bot.find(params[:id])
    @bot.destroy
    flash[:notice] = "Bot '#{@bot.name}' deleted."
    redirect_to bots_path
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @bot = Bot.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  private
  def bot_params
    params.require(:bot).permit(:name, :movingAverage1, :movingAverage2, :short)
  end
end


