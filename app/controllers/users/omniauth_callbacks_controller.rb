module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google
      auth_params = request.env['omniauth.auth']
      @user = User.find_for_google(auth_params)

      if @user.persisted?
        flash[:success] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, event: :authentication
        session[:user_id] = @user.id
      else
        session['devise.google_data'] = auth_params
        redirect_to new_user_registration_url
      end
    end
  end
end
