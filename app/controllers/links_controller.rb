class LinksController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    link.destroy if authorize! :destroy, link.linkable
  end

  private

  def link
    @link = Link.find(params[:id])
  end

  helper_method :link
end
