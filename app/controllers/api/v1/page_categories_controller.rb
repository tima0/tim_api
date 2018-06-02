class Api::V1::PageCategoriesController < ApplicationController

  before_filter :admin_token_access

  #	
	# Returns a list of all of the page categories sorted in order by sort_id.
	# Also, each page category comes with an array of all of the pages that belong 
	# to the category. And if the category belongs to a department, it will also
	# return that department.
	#
	# Request: 
  #
	#  GET: /api/v1/page_categories
  #  
	# Response: 
	#
	#  {
	#      "page_categories": [
	#           {
	#             "public": {
	#                 "title": "Fundamental",
	#                 "body": "...",
	#                 "url_slug": "fundamental",
	#                 "apikey": "ae1c9e285aa953610a9a823612932c71",
	#                 "cover_image_file_name": null,
	#                 "cover_image_content_type": null,
	#                 "cover_image_file_size": null,
	#                 "cover_image_updated_at": null
	#             },
	#             "pages": [
	#                 {
	#                     "public": {
	#                         "title": "software",
	#                         "body": "...",
	#                         "url_slug": "software",
	#                         "apikey": "ad414cbad7a4dae774a94e0330dc5937"
	#                     }
	#                 },
	#                 {
	#                     "public": {
	#                         "title": "Realigned",
	#                         "body": "...",
	#                         "url_slug": "realigned",
	#                         "apikey": "fc83feb55aeb8a3fb6393831579647e7"
	#                     }
	#                 }
	#             ],
	#             "department": {
	#                 "public": {
	#                     "name": "Planning & Zoning",
	#                     "description": null,
	#                     "status": null,
	#                     "url_slug": "planning_zoning",
	#                     "apikey": "9add0c49b1a422fd7df96f6d9a900631",
	#                     "cover_image_file_name": null,
	#                     "cover_image_content_type": null,
	#                     "cover_image_file_size": null,
	#                     "cover_image_updated_at": null,
	#                     "created_at": "2017-08-07T19:08:20.000Z",
	#                     "updated_at": "2017-08-07T19:08:20.000Z"
	#                 }
	#             }
	#         },
	#         {
	#             "public": {
	#                 "title": "open architecture",
	#                 "body": "...",
	#                 "url_slug": "open_architecture",
	#                 "apikey": "083ae688e893e6eb923da714daced46d",
	#                 "cover_image_file_name": null,
	#                 "cover_image_content_type": null,
	#                 "cover_image_file_size": null,
	#                 "cover_image_updated_at": null
	#             },
	#             "pages": [
	#                 {
	#                     "public": {
	#                         "title": "dedicated",
	#                         "body": "...",
	#                         "url_slug": "dedicated",
	#                         "apikey": "16284ee341637349a5dd1b179061d4b4"
	#                     }
	#                 }
	#             ],
	#             "department": {
	#                 "public": {
	#                     "name": "Landfill",
	#                     "description": null,
	#                     "status": null,
	#                     "url_slug": "landfill",
	#                     "apikey": "9abf660cc63460bb3d4d8996a1a2a829",
	#                     "cover_image_file_name": null,
	#                     "cover_image_content_type": null,
	#                     "cover_image_file_size": null,
	#                     "cover_image_updated_at": null,
	#                     "created_at": "2017-08-07T19:08:20.000Z",
	#                     "updated_at": "2017-08-07T19:08:20.000Z"
	#                 }
	#             }
	#         },
	#         {
	#             "public": {
	#                 "title": "hub",
	#                 "body": "...",
	#                 "url_slug": "hub",
	#                 "apikey": "7a82a08ca560a72e34c7e89a94c5b922",
	#                 "cover_image_file_name": null,
	#                 "cover_image_content_type": null,
	#                 "cover_image_file_size": null,
	#                 "cover_image_updated_at": null
	#             },
	#             "pages": [
	#                 {
	#                     "public": {
	#                         "title": "5th generation",
	#                         "body": "...",
	#                         "url_slug": "5th_generation",
	#                         "apikey": "5a0f4ee9eda84cb0b5e6bf58f05a3fc3"
	#                     }
	#                 },
	#                 {
	#                     "public": {
	#                         "title": "Balanced",
	#                         "body": "...",
	#                         "url_slug": "balanced",
	#                         "apikey": "2c53878c0173a72a2d13f42922a706f7"
	#                     }
	#                 }
	#             ],
	#             "department": {
	#             }
	#         },
	# 		]
	#  }
  def index
    page_categories = PageCategory.all.sort
    if page_categories
      render json: {page_categories: page_categories}.to_json, status: 200
    else
      render json: {error: "Could not find page categories"}.to_json, status: 400
    end
  end


  #	
	# Returns a single page gategory along with it's pages and department
	# 
	# Request: 
  #
	#  GET: /api/v1/page_categories/:apikey
  #  
	# Response: 
	#
	#  {
	#     "page_category": {
	#         "public": {
	#             "title": "Fundamental",
	#             "body": "...",
	#             "url_slug": "fundamental",
	#             "apikey": "ae1c9e285aa953610a9a823612932c71",
	#             "cover_image_file_name": null,
	#             "cover_image_content_type": null,
	#             "cover_image_file_size": null,
	#             "cover_image_updated_at": null
	#         },
	#         "pages": [
	#             {
	#                 "public": {
	#                     "title": "software",
	#                     "body": "...",
	#                     "url_slug": "software",
	#                     "apikey": "ad414cbad7a4dae774a94e0330dc5937"
	#                 }
	#             },
	#             {
	#                 "public": {
	#                     "title": "Realigned",
	#                     "body": "...",
	#                     "url_slug": "realigned",
	#                     "apikey": "fc83feb55aeb8a3fb6393831579647e7"
	#                 }
	#             }
	#         ],
	#         "department": {
	#             "public": {
	#                 "name": "Planning & Zoning",
	#                 "description": null,
	#                 "status": null,
	#                 "url_slug": "planning_zoning",
	#                 "apikey": "9add0c49b1a422fd7df96f6d9a900631",
	#                 "cover_image_file_name": null,
	#                 "cover_image_content_type": null,
	#                 "cover_image_file_size": null,
	#                 "cover_image_updated_at": null,
	#                 "created_at": "2017-08-07T19:08:20.000Z",
	#                 "updated_at": "2017-08-07T19:08:20.000Z"
	#             }
	#         }
	#     }
	#  }
  def show
    page_category = PageCategory.find_by_apikey(params[:id])
    if page_category
      render json: {page_category: page_category}.to_json, status: 200
    else
      render json: {error: "Could not find page category"}.to_json, status: 400
    end
  end

  def create
  end

  def update
  end

  def destroy
  end


  #	
	# This endpoint will let you change the order in which departments will appear. 
	# You will need to supply an array of valid department apikey's. It will return nothing.
	#
	# =====Required Params Example
  #
	#  dept[]=05252591447c7a6b50482f80e80f3454&dept[]=4522a0b48f8e6f881be5abe9c33f04da&dept[]=f0fbc0e8925ab475ead1dda33e9e5f80&dept[]=2c7ca79f747b3975bbafecf00967cdee&dept[]=aa964d44c320747f1f809e301284a666&dept[]=2d0514e004077c406f0ad8e738d4e6c0&dept[]=3ad6eb335869eb0b559f1cb3d4b39566
  #  
	#
	# =====Request 
  #
	#  POST: /api/v1/page_categories/sort
  #  
	# =====Response 
	# 
	#
  def sort_page_categories
    params[:pc].each_with_index {|val, index|
      obj = PageCategory.find_by_apikey(val)
      obj.update_attribute(:sort_order, index)
    }
    render :text => ""
  end

end
