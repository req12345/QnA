class AttachmentsController < ApplicationController
  def destroy
    attachment.purge if current_user&.author_of?(attachment.record)
  end

  private

  def attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  helper_method :attachment
end
