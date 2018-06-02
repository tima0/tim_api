class Api::V1::PagesController < ApplicationController

  before_filter :admin_token_access


  def index
  end

  def show
    page = Page.find_by_apikey(params[:id])
    if page
      render json: {page: page}.to_json, status: 200
    else
      render json: {error: "Could not find page"}.to_json, status: 400
    end
  end

  def create
  end

  def update
  end

  def destroy
  end
end
