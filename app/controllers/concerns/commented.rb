module Commented
  extend ActiveSupport::Concern

  included do
    after_action :publish_comment, only: [:create_comment]
  end

  def create_comment
    @comment = set_commentable.comments.create(comment_params.merge(user: current_user))
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    model_klass.find(params[:id])
  end

  def publish_comment
    return if @comment.errors.any?
    id = @comment.commentable_type == "Answer" ? @comment.commentable.question.id : @comment.commentable.id
    ActionCable.server.broadcast("comments/#{id}",
      ApplicationController.render(json: {
        comment: @comment.as_json(only: %i[commentable_type commentable_id]),
        html_content: render_to_string(partial: 'comments/comment', locals: {comment: @comment})
      })
    )
  end
end
