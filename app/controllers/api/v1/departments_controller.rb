class Api::V1::DepartmentsController < ApplicationController

  before_filter :admin_token_access


  #	
	# Returns a list of all of the departments sorted in order by sort_id.
	#
	# Request: 
  #
	#  GET: /api/v1/departments
  #  
	# Response: 
	#
	#   {
	#	   "departments": [
	#   		{
	#   			"id": 1,
	#   			"name": "architect",
	#   			"description": null,
	#   			"status": null,
	#   			"sort_order": "0",
	#   			"admin_id": 3,
	#   			"apikey": "05252591447c7a6b50482f80e80f3454",
	#   			"created_at": "2017-04-02T17:24:49.000Z",
	#   			"updated_at": "2017-04-02T17:37:23.000Z",
	#   			"cover_image_file_name": null,
	#   			"cover_image_content_type": null,
	#   			"cover_image_file_size": null,
	#   			"cover_image_updated_at": null
	#   		},
	#   		{
	#   			"id": 5,
	#   			"name": "designer",
	#   			"description": null,
	#   			"status": null,
	#   			"sort_order": "1",
	#   			"admin_id": 2,
	#   			"apikey": "4522a0b48f8e6f881be5abe9c33f04da",
	#   			"created_at": "2017-04-02T17:24:49.000Z",
	#   			"updated_at": "2017-04-02T17:37:23.000Z",
	#   			"cover_image_file_name": null,
	#   			"cover_image_content_type": null,
	#   			"cover_image_file_size": null,
	#   			"cover_image_updated_at": null
	#   		},
	#   		{
	#   			"id": 2,
	#   			"name": "programmer",
	#   			"description": null,
	#   			"status": null,
	#   			"sort_order": "2",
	#   			"admin_id": 1,
	#   			"apikey": "f0fbc0e8925ab475ead1dda33e9e5f80",
	#   			"created_at": "2017-04-02T17:24:49.000Z",
	#   			"updated_at": "2017-04-02T17:37:09.000Z",
	#   			"cover_image_file_name": null,
	#   			"cover_image_content_type": null,
	#   			"cover_image_file_size": null,
	#   			"cover_image_updated_at": null
	#   		},
	#   		{
	#   			"id": 3,
	#   			"name": "astronomer",
	#   			"description": null,
	#   			"status": null,
	#   			"sort_order": "3",
	#   			"admin_id": 4,
	#   			"apikey": "2c7ca79f747b3975bbafecf00967cdee",
	#   			"created_at": "2017-04-02T17:24:49.000Z",
	#   			"updated_at": "2017-04-02T17:37:09.000Z",
	#   			"cover_image_file_name": null,
	#   			"cover_image_content_type": null,
	#   			"cover_image_file_size": null,
	#   			"cover_image_updated_at": null
	#   		},
	#   	]
	#  }
  def index
    departments = Department.all.sort
    if departments
      render json: {departments: departments}.to_json, status: 200
    else
      render json: {error: "Could not find departments"}.to_json, status: 400
    end
  end




  #	
	# Returns a json object for a single department with its admin/owner and page categories.
	#	 
	#
	# Request: 
  #
	#  GET: /api/v1/departments/:apikey
  #  
	# Response: 
	#
	#	{
	#		"department": {
	#			"public": {
	#				"name": "Parks and Rec",
	#				"description": null,
	#				"status": null,
	#				"url_slug": "parks_and_rec",
	#				"apikey": "d9f3e692b853dc591d4bd716e19cc2f6",
	#				"cover_image_file_name": null,
	#				"cover_image_content_type": null,
	#				"cover_image_file_size": null,
	#				"cover_image_updated_at": null,
	#				"created_at": "2017-04-09T00:46:19.000Z",
	#				"updated_at": "2017-04-09T00:46:19.000Z"
	#			},
	#			"admin": {
	#				"private_profile": {
	#					"first_name": "Leia",
	#					"last_name": "Organa",
	#					"title": "Rebel Leader",
	#					"email": "leia@pxp200.com",
	#					"apikey": "20525660e179da52fb9c603d58d1092c"
	#				}
	#			},
	#			"page_categories": [
	#				{
	#					"public": {
	#						"title": "6th generation",
	#						"url_slug": "6th_generation",
	#						"apikey": "055c1197cfb0db44d0dc898165c628e8",
	#						"cover_image_file_name": null,
	#						"cover_image_content_type": null,
	#						"cover_image_file_size": null,
	#						"cover_image_updated_at": null
	#					}
	#				},
	#				{
	#					"public": {
	#						"title": "client-driven",
	#						"url_slug": "client_driven",
	#						"apikey": "64f8597713179094b4ee3360fa86a223",
	#						"cover_image_file_name": null,
	#						"cover_image_content_type": null,
	#						"cover_image_file_size": null,
	#						"cover_image_updated_at": null
	#					}
	#				}
	#			]
	#		}
	#	}
  def show
    department = Department.find_by_apikey(params[:id])
    if department
      render json: {department: department}.to_json, status: 200
    else
      render json: {error: "Could not find department"}.to_json, status: 400
    end
  end




  #	
	# The ID of the admin who created the department will automatically
	# be assigned as the admin for this department.
	#
	# The sort order will default to be the same as the id. And the url_slug 
	# will default to be a parameterized version of the name.
	#
	# The status will default to "pending". It won't show up in the index
	# of departments until it has a status of "published".
	#
	# =====Required Params 
  #
	#  name (unique)
  #  
	#
	# =====Optional Params 
  #
	#  description
	#  cover_image
  #  
	#
	# =====Request 
  #
	#  POST: /api/v1/departments
  #  
	# =====Response 
	#
	#		{
	#			"department": {
	#				"public": {
	#					"name": "City Council",
	#					"description": null,
	#					"status": "pending",
	#					"url_slug": "city_council",
	#					"apikey": "d7e3f410a5ca877f411e53b7b74e7f4e",
	#					"cover_image_file_name": null,
	#					"cover_image_content_type": null,
	#					"cover_image_file_size": null,
	#					"cover_image_updated_at": null,
	#					"created_at": "2017-04-03T00:05:21.406Z",
	#					"updated_at": "2017-04-03T00:05:21.411Z"
	#				},
	#				"admin": {
	#					"private_profile": {
	#						"first_name": "Anakin",
	#						"last_name": "Skywalker",
	#						"title": "Jedi Knight",
	#						"email": "anakin@pxp200.com",
	#						"apikey": "5029a308c00416fa173682185f31c4af"
	#					}
	#				}
	#			}
	#		}
  def create
    department = Department.new(department_params)
    department.admin_id = @current_admin.id
    department.status = "pending"
    if department.save
      render json: {department: department}.to_json, status: 200
    else
      render json: {error: department.errors.full_messages.to_sentence}.to_json, status: 400
    end
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
	#  POST: /api/v1/departments/sort
  #  
	# =====Response 
	# 
	#
  def sort
    params[:dept].each_with_index {|val, index|
      obj = Department.find_by_apikey(val)
      obj.update_attribute(:sort_order, index)
    }
    render :text => ""
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
	#  POST: /api/v1/departments/sort_page_categories
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
	#  POST: /api/v1/departments/sort_page_categories
  #  
	# =====Response 
	# 
	#
  def sort_pages
    params[:page].each_with_index {|val, index|
      obj = Page.find_by_apikey(val)
      obj.update_attribute(:sort_order, index)
    }
    render :text => ""
  end




  private

  def department_params
    params.permit(:name, :cover_image)
  end
end
