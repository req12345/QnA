class SearchController < ApplicationController
  skip_authorization_check

  def search
    service = SearchService.new(search_params)
    @result = service.call
  end

  private

  def search_params
    params.permit(:body, :type)
  end
end
