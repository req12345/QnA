module Voted
  extend ActiveSupport::Concern

  def vote_for
    set_votable
    @votable.vote_for(current_user)
    render json: { resource_name: @votable.class.name.underscore,
                 resource_id: @votable.id,
                 rating: @votable.rating}
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
