class Users::RegistrationsController < Devise::RegistrationsController
    def create
      # Check if it's the first user
      if User.count == 0
        @user = User.new(sign_up_params)
        @user.admin = true  # Set the first user as admin
      else
        @user = User.new(sign_up_params)
      end
  
      if @user.save
        # If the user was successfully saved, sign them in
        sign_in(@user)
        redirect_to root_path, notice: 'Welcome! You have signed up successfully.'
      else
        render :new
      end
    end
  
    private
  
    def sign_up_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
  end
  