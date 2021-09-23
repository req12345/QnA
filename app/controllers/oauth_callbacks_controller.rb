class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    oauth('Github')
  end

  def vkontakte
    oauth('Vkontakte')
  end

  def oauth(provider)

    unless request.env['omniauth.auth'].info[:email]
      redirect_to users_set_email_path
      return
    end

    @user = FindForOauthService.new(request.env['omniauth.auth']).call

    if @user&.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
