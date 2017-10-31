class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  @search_form = true

  before_action :configure_devise_permitted_parameters, if: :devise_controller?

  protected
  def configure_devise_permitted_parameters
    registration_params = [
        :first_name, :last_name, :address, :gender, :DOB, 
        :email, :password, :password_confirmation, 
        :image, :thumb, :medium
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
end
