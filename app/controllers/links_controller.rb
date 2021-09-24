class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    if current_user
      link.destroy if authorize! :destroy, link.linkable
    end
  end

  private

  def link
    @link = Link.find(params[:id])
  end

  helper_method :link
end
