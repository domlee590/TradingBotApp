class UsersController < ApplicationController

  skip_before_action :authorized, only: [:new, :create]
  def new
    @user = User.new
  end

  def create
    begin
      @user = User.create(params.require(:user).permit(:username, :password))
    rescue
      flash[:error] = "Username already exists"
      redirect_to new_user_path
    else
      session[:user_id] = @user.id
      redirect_to root_path
    end
  end

end
