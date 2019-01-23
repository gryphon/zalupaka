class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end
  
  before_action :set_locale
   
  def set_locale

    I18n.locale = params[:locale] || session[:locale] || http_accept_language.compatible_language_from(I18n.available_locales)


  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  protected

  def configure_permitted_parameters
    # Only add some parameters

    devise_parameter_sanitizer.for(:invite).concat [:role, :company_id, :username]

    devise_parameter_sanitizer.for(:accept_invitation).concat [:username]

  end

  
end
