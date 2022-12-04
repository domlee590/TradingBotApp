class EdusController < ApplicationController
  def index
    @edus = Edu.all
  end

  def show
    id = params[:id] # retrieve bot ID from URI route
    @edu = Edu.find(id) # look up bot by unique ID
  end
end
