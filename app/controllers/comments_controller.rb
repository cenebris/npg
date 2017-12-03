class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    if Comment.create(comment_params)
      flash[:notice] = 'Comment created'
    else
      flash[:danger] = 'Error'
    end
    redirect_to movie_path(params[:movie_id])
  end

  def destroy
    if Comment.find(params[:comment_id]).delete
      flash[:notice] = 'Comment deleted'
    else
      flash[:danger] = 'Error'
    end
    redirect_to movie_path(params[:movie_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(movie_id: params[:movie_id],
                                                 user_id: current_user.id)
  end



end