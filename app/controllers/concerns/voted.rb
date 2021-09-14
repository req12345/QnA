module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_for vote_against]
  end

  def vote_for
    @votable.vote_for(current_user)
    render_response
  end

  def vote_against
    @votable.vote_against(current_user)
    render_response
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def render_response
    render json: { resource_name: @votable.class.name.underscore,
                 resource_id: @votable.id,
                 rating: @votable.rating }
  end
end
