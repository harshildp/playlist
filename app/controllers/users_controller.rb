class UsersController < ApplicationController
  def new
  end

  def show
    @user = current_user
    @songs = Song.joins(:adds).group('songs.id').order('count(adds.user_id) desc').where('adds.user_id = ?', @user.id)
    # @songs = Song.includes(:users).references(:users)
    # @songs = @songs.reject{ |s| s.users.exclude? @user }
    # @songs = @songs.group('songs.id').where(adds.user_id = 1).order('count(adds.user_id) desc')
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
end
