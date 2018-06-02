class Api::V1::AdminsController < ApplicationController

  before_filter :admin_token_access, :except => [:create, :authenticate]


	#Get Admin
	def show
		admin = Admin.find_by_apikey(params[:id])
		if admin && @current_admin_token == admin.apikey #dont let others view my profile 
			render :json => {"admin" => admin}.as_json, :status => 200 
		else
			render :json => {:error => "Could not find admin"}.to_json, :status => 400
		end
	end

  #Create Admin
  def create
    admin = Admin.new(signup_params)
    admin.status = "pending"
    if admin.save
      render json: {admin: admin}.to_json, status: 200
    else
      render json: {error: admin.errors.full_messages.to_sentence}.to_json, status: 400
    end
  end

  #Authenticate Admin
  def authenticate
    admin = Admin.authenticate(params[:email], params[:password])
    if admin && admin.status == "active"
      render json: {admin: admin}.as_json, status: 200
      #render :json => {"admin" => admin}.as_json, :status => 200 
    else
      render json: {error: "Authentication failed"}.to_json, status: 400
    end
  end


  private

  def signup_params
    params.permit(:first_name, :last_name, :title, :email, :password, :password_confirmation) 
  end

end
