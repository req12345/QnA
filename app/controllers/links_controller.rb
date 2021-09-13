class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    if current_user&.author_of?(link.linkable)
      link.destroy
    end
  end

  private

  def link
    @link = Link.find(params[:id])
  end

  helper_method :link
end
