class EdusController < ApplicationController
  def index
    @edus = Edu.all
  end

  def show

    if params[:fetch] == "true"
      @run = "T"
    end

    id = params[:id] # retrieve bot ID from URI route
    @edu = Edu.find(id) # look up bot by unique ID
    @edu_output = EduOut.where(edu_id: id).last

    edu_output_raw = EduOut.where(edu_id: id)

    @chart_data_pnl = []
    @chart_data_wr = []
    @chart_data_tc = []
    edu_output_raw.each do |edu_output|
      @chart_data_pnl << [edu_output.time, edu_output.pnl]
      @chart_data_wr << [edu_output.time, edu_output.wr]
      @chart_data_tc << [edu_output.time, edu_output.tc]
    end
  end

  def copybot
    currentUserID = session[:user_id]
    currentUsername = User.find(currentUserID).username

    id = params[:format] # retrieve bot ID from URI route
    @edu = Edu.find(id) # look up bot by unique ID

    data = @edu.attributes
    data[:username] = currentUsername
    data.delete("channel")
    data.delete("youtube_id")
    data.delete("link")
    data.delete("description")
    data.delete("run")
    data.delete("id")

    @bot = Bot.create!(data)
    flash[:notice] = "#{@bot.name} was successfully created."
    redirect_to bots_path
  end
end
