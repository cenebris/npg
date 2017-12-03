class CommentDecorator < Draper::Decorator
  include ActionView::Helpers::DateHelper
  delegate_all

  def email
    user.email
  end

  def created
    "#{time_ago_in_words(created_at)} ago"
  end
end
