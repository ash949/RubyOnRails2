class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  @search_form = true


  # this block of code is to permit first_name and last_name for params in devise registeration controller
  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  protected
  def configure_devise_permitted_parameters
    registration_params = [
        :first_name, :last_name, 
        :email, :password, :password_confirmation
    ]

    if params[:action] == 'update'
      devise_parameter_sanitizer.permit(:account_update) { 
        |u| u.permit(registration_params << :current_password)
      }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.permit(:sign_up) { 
        |u| u.permit(registration_params) 
      }
    end
  end
  #------------------------------------------------------------------

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, alert: exception.message
  end
end
