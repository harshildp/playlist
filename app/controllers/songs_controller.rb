class SongsController < ApplicationController
  def index
    @user = current_user
    @songs = Song.joins(:adds).group('songs.id').order('count(adds.user_id) desc')
  end

  def create
    @song = Song.new(song_params)
    if not @song.save
      @song.errors.each do |tag, error|
        flash[tag.to_sym] ||= []
        flash[tag.to_sym] << error
      end
    end
    Add.create(song_id: @song.id, user_id:session[:user_id])
    redirect_to songs_path
  end

  def show
    @user = current_user
    @song = Song.find(params[:id])
    @users = @song.users.group('users.id').order('count(adds.user_id) desc')
    # @song = Song.joins(:users, :adds).group('songs.id').order('count(adds.user_id) desc').where(id:params[:id])
    # @song = Song.includes(:users, :adds).group('songs.id').order('count(adds.user_id) desc').where(id:params[:id]).references(:users, :adds)
    # @song = @song.first
  end

  private
  def song_params
    params.require(:song).permit(:title, :artist)
  end
end
