class AttachmentsController < ApplicationController
  def destroy
    attachment.purge if authorize! :destroy, attachment
  end

  private

  def attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  helper_method :attachment
end
