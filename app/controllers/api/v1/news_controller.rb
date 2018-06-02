class Api::V1::NewsController < ApplicationController
  # Secure the controller
  before_filter :admin_token_access

  #
  # Returns a list of all news items (active or inactive) sorted by created_at date/time.
  #
  # =====Request
  #
  #  GET: /api/v1/news
  #
  # =====Response
  #   {
  #     "news": [
  #         {
  #             "public": {
  #                 "title": "human-resource",
  #                 "content": "Expanded dedicated methodology",
  #                 "apikey": "7b7369b21fd34abd443b3037146c5fcb",
  #                 "url_slug": "human_resource",
  #                 "created_at": "2017-07-14T19:50:22.000Z",
  #                 "updated_at": "2017-07-14T19:50:22.000Z"
  #             },
  #             "admin": {
  #                 "private_profile": {
  #                     "first_name": "Leia",
  #                     "last_name": "Organa",
  #                     "title": "Rebel Leader",
  #                     "email": "leia@pxp200.com",
  #                     "apikey": "4db7f0082e71399df88c62b88eb8572a"
  #                 }
  #             }
  #         },
  #         {
  #             "public": {
  #                 "title": "Ergonomic",
  #                 "content": "Optional content-based utilisation",
  #                 "apikey": "409972b0bffba3dd0318dfc793c2cf54",
  #                 "url_slug": "ergonomic",
  #                 "created_at": "2017-07-14T19:50:22.000Z",
  #                 "updated_at": "2017-07-14T19:50:22.000Z"
  #             },
  #             "admin": {
  #                 "private_profile": {
  #                     "first_name": "Han",
  #                     "last_name": "Solo",
  #                     "title": "Smugler",
  #                     "email": "han@pxp200.com",
  #                     "apikey": "3c736e170fb9f55dd66beebe5ebdaad3"
  #                 }
  #             }
  #         }
  #     ]
  #   }
  def index
    news = News.all.order(created_at: :desc)
    if news
      render json: {news: news}.to_json, status: 200
    else
      render json: {error: "Could not find news"}.to_json, status: 400
    end
  end




  #
  # Returns a single news item.
  #
  # =====Request
  #
  #  GET: /api/v1/news/{{apikey}}
  #
  # =====Response
  #   {
  #     "news": {
  #         "public": {
  #             "title": "Ergonomic",
  #             "content": "Optional content-based utilisation",
  #             "apikey": "409972b0bffba3dd0318dfc793c2cf54",
  #             "url_slug": "ergonomic",
  #             "created_at": "2017-07-14T19:50:22.000Z",
  #             "updated_at": "2017-07-14T19:50:22.000Z"
  #         },
  #         "admin": {
  #             "private_profile": {
  #                 "first_name": "Han",
  #                 "last_name": "Solo",
  #                 "title": "Smugler",
  #                 "email": "han@pxp200.com",
  #                 "apikey": "3c736e170fb9f55dd66beebe5ebdaad3"
  #             }
  #         }
  #     }
  #   }
  def show
    news = News.find_by_apikey(params[:id])
    if news
      render json: {news: news}.to_json, status: 200
    else
      render json: {error: "Could not find news"}.to_json, status: 400
    end
  end



  #	
	# The ID of the admin who created the news item will automatically
	# be assigned as the admin for this department.
	#
	# The sort order will default to be the same as the id. And the url_slug 
	# will default to be a parameterized version of the title.
	#
	# =====Required Params 
  #
	#  title (unique)
  #  content
  #  
	# =====Request 
  #
	#  POST: /api/v1/news
  #  
	# =====Response 
	#
  #   {
  #     "news": {
  #         "public": {
  #             "title": "THIS WAS CREATED",
  #             "content": "NEWS CONTENT",
  #             "apikey": "3f36010c223e51757b7dc0e042ac8911",
  #             "url_slug": "this_was_created",
  #             "created_at": "2017-07-14T20:56:39.000Z",
  #             "updated_at": "2017-07-14T20:56:39.000Z"
  #         },
  #         "admin": {
  #             "private_profile": {
  #                 "first_name": "Anakin",
  #                 "last_name": "Skywalker",
  #                 "title": "Jedi Knight",
  #                 "email": "anakin@pxp200.com",
  #                 "apikey": "51b539192d8945efb5094cf82e106d91"
  #             }
  #         }
  #     }
  #   }
  def create
    news = News.new(news_params)
    news.admin_id = @current_admin.id
    if news.save
      news.reload
      render json: {news: news}.to_json(include: :tags), status: 200
    else
      render json: {error: news.errors.full_messages.to_sentence}.to_json, status: 400
    end
  end



	# =====Required Params 
  #
	#  apikey
  #  
	# =====Request 
  #
	#  PUT: /api/v1/news/{{apikey}}
  #  
	# =====Response 
	#
  #   {
  #     "news": {
  #         "public": {
  #             "title": "THIS WAS MODIFIED",
  #             "content": "NEWS CONTENT",
  #             "apikey": "3f36010c223e51757b7dc0e042ac8911",
  #             "url_slug": "this_was_created",
  #             "created_at": "2017-07-14T20:56:39.000Z",
  #             "updated_at": "2017-07-14T20:56:39.000Z"
  #         },
  #         "admin": {
  #             "private_profile": {
  #                 "first_name": "Anakin",
  #                 "last_name": "Skywalker",
  #                 "title": "Jedi Knight",
  #                 "email": "anakin@pxp200.com",
  #                 "apikey": "51b539192d8945efb5094cf82e106d91"
  #             }
  #         }
  #     }
  #   }
  def update
    news = News.find_by_apikey(params[:id])
    if news
      news.assign_attributes(news_params)
      news.save
      render json: {news: news}.to_json, status: 200
    else
      render json: {error: "News #{params[:id]} not found", status: 400}
    end
  end



	# =====Required Params 
  #
	#  apikey
  #  
	# =====Request 
  #
	#  DELETE: /api/v1/news/{{apikey}}
  #  
	# =====Response 
	#
  #   {
  #     "news": {
  #         "public": {
  #             "title": "THIS WAS CREATED",
  #             "content": "NEWS CONTENT",
  #             "apikey": "3f36010c223e51757b7dc0e042ac8911",
  #             "url_slug": "this_was_created",
  #             "created_at": "2017-07-14T20:56:39.000Z",
  #             "updated_at": "2017-07-14T20:56:39.000Z"
  #         },
  #         "admin": {
  #             "private_profile": {
  #                 "first_name": "Anakin",
  #                 "last_name": "Skywalker",
  #                 "title": "Jedi Knight",
  #                 "email": "anakin@pxp200.com",
  #                 "apikey": "51b539192d8945efb5094cf82e106d91"
  #             }
  #         }
  #     }
  #   }
  def destroy
    news = News.find_by_apikey(params[:id])
    if news
      news.delete
      render json: {news: news}.to_json, status: 200
    else
      render json: {error: "News #{params[:id]} not found", status: 400}
    end
  end

  private

  def news_params
    params.permit(:title, :content)
  end
end
