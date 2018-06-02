class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session


	def admin_token_access
		authenticate_or_request_with_http_token do |token, options|
			admin = Admin.exists?(:apikey => token, :status => "active")
			if admin
				@current_admin = Admin.find_by_apikey(token)
				@current_admin_token = token
			else
				@current_admin = nil 
				@current_admin_token = token 
				render json: { error: "Admin Authentication failed" }, :status => 401
			end
		end
	end

end
