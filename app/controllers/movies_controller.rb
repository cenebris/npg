class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:send_info]

  def index
    render 'movies/index', locals: { movies: movies }
  end

  def show
    render 'movies/show', locals: { movie: movie,
                                    comments: comments,
                                    new_comment: new_comment }
  end

  def send_info
    MovieInfoMailer.send_info(current_user, movie).deliver_now
    redirect_back(fallback_location: root_path, notice: 'Email sent with movie info')
  end

  def export
    file_path = "tmp/movies.csv"
    MovieExporter.new.call(current_user, file_path)
    redirect_to root_path, notice: "Movies exported"
  end

  private

  def commenting_possible?
    return false if current_user.nil? || already_commented?
    true
  end

  def already_commented?
    movie.comments.exists?(user: current_user)
  end

  def new_comment
    commenting_possible? ? Comment.new(movie: movie, user: current_user) : nil
  end

  def movie
    @movie ||= Movie.find(params[:id])
  end

  def movies
    @movies ||= Movie.all.decorate
  end

  def comments
    @comments ||= movie.comments.decorate
  end
end
