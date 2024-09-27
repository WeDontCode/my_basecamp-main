class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy set_admin remove_admin]
  before_action :authenticate_user!
  before_action :authorize_admin, only: [ :destroy, :set_admin, :remove_admin ]

  # GET /users or /users.json
  def index
    @users = User.all.includes(:projects) # Ensure to include projects if needed
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    # Remove password fields if they are blank to avoid errors
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: "User was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to users_url, alert: "User could not be destroyed." }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH
  def set_admin
    @user.update(admin: true)
    redirect_to users_path, notice: "#{@user.email} is now an admin."
  rescue ActiveRecord::RecordInvalid
    redirect_to users_path, alert: "Failed to set admin status."
  end

  # PATCH
  def remove_admin
    @user.update(admin: false)
    redirect_to users_path, notice: "#{@user.email} is no longer an admin."
  rescue ActiveRecord::RecordInvalid
    redirect_to users_path, alert: "Failed to remove admin status."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_url, alert: "User not found."
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :admin).except(:reset_password_token, :confirmation_token)
  end


  # Authorization check to ensure only admins can perform certain actions.
  def authorize_admin
    redirect_to(root_path, alert: "Not authorized") unless current_user.admin?
  end
end
