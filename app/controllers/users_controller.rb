class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :auth, except: [:new, :create]  
  
  def new
  end

  def show
    @user = current_user
    @songs = Song.joins(:adds).group('songs.id').order('count(adds.user_id) desc').where('adds.user_id = ?', @user.id)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to songs_path
    else 
      @user.errors.each do |tag, error|
        flash[tag.to_sym] ||= []
        flash[tag.to_sym] << error
      end
      redirect_to signin_path
    end
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end      

    def auth 
      redirect_to show_user_path(session[:user_id]) unless params[:id] == session[:user_id].to_s
    end
end
