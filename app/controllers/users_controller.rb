# user controller
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index]
  load_and_authorize_resource except: %i[index]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.skip_confirmation! if current_user.admin?
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User created successfully.' }
        format.json { render :show, status: :created, location: @user }
      else
        handle_create_user_errors(flash, format, @user)
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    updated = if params[:user][:password].blank?
                @user.update_without_password(user_params_no_password)
              else
                @user.update(user_params)
              end

    if updated
      redirect_to @user, notice: 'User has successfully been updated'
    else
      redirect_to @user, flash: { error: @user.errors.full_messages }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html do
        redirect_to users_url, notice: 'User was successfully removed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    error_message = 'No valid ID provided to show the object'
    @user = User.find(params[:id])
  rescue ActiveRecord::ActiveRecordError
    redirect_to root_url, alert: error_message
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def user_params
    if current_user.admin?
      params.require(:user).permit(
        :first_name, :last_name, :email,
        :password, :password_confirmation, :admin
      )
    else
      params.require(:user).permit(
        :first_name, :last_name, :password, :password_confirmation
      )
    end
  end

  def user_params_no_password
    if current_user.admin?
      params.require(:user).permit(:first_name, :last_name, :email, :admin)
    else
      params.require(:user).permit(:first_name, :last_name)
    end
  end

  def handle_create_user_errors(flash, format, user)
    flash[:error] = user.errors.full_messages
    flash[:model] = 'user'
    format.html { render :new }
    format.json do
      render json: user.errors, status: :unprocessable_entity
    end
  end
end
