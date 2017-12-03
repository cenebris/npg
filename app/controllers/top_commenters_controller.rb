class TopCommentersController < ApplicationController

  def show
    render 'movies/top_commenters',
           locals: { top_commenters_all_time: TopCommentersController.top_commenters_all_time,
                     top_commenters_this_week: TopCommentersController.top_commenters_this_week }
  end

  def self.top_commenters_this_week
    Rails.cache.fetch('query_top_commenters_this_week', expires_in: 1.day) do
      User.where('comments_count > ?', 0).
          joins(:comments).
          where('comments.created_at > ?', 1.week.ago).
          group(:id).
          count.
          sort_by{|_, v| v}.
          reverse.
          first(10).
          map{|k,v| {email: User.find(k).email, comments_count: v}}
    end
  end

  def self.top_commenters_all_time
    Rails.cache.fetch('query_top_commenters_all_time', expires_in: 1.day) do
      User.order('comments_count DESC').
          limit(10).
          pluck(:email, :comments_count).
          select{|_,v| v !=0 }
    end
  end
end
