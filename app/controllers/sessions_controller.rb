class SessionsController < ApplicationController
  def create
    @user = User.find_by(email:params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to songs_path
    else 
      flash[:invalid] = ["email/password"]
      redirect_to signin_path
    end
  end

  def destroy
      reset_session
      redirect_to signin_path
  end
end
