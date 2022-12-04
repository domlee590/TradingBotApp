class EdusController < ApplicationController
  def index
    @edus = Edu.all
  end

  def show
    id = params[:id] # retrieve bot ID from URI route
    @edu = Edu.find(id) # look up bot by unique ID
  end

  def backtest
    id = params[:format]
    Edu.update(id, :run => true)
  end

  def stoptest
    id = params[:format]
    Edu.update(id, :run => false)
  end
end
