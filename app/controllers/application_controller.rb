class ApplicationController < ActionController::Base
  before_action :authenticate_user! # Ensure users are authenticated before accessing any controller actions

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Optional: This can be included if you want to restrict access to admins
  def authorize_admin
    redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  end
end
