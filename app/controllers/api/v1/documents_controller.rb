class Api::V1::DocumentsController < ApplicationController

  # Secure the controller
  before_filter :admin_token_access

  #
  # Returns a list of all documents sorted by sort_order.
  #
  # =====Request
  #
  #  GET: /api/v1/documents
  #
  # =====Response
  #
  #   {
  #     "documents": [
  #         {
  #             "public": {
  #                 "title": "Document title 1",
  #                 "description": "This is the description for the first docuemnt ",
  #                 "file_type": "application/pdf",
  #                 "file_url": "http://s3.amazonaws.com/saltcms-test-setup/uploaders/attachments/000/000/016/original/Hampton_Roads_RFP.pdf?1500390273",
  #                 "apikey": "b2000ee2efba79894da7a3167a009d78",
  #                 "created_at": "2017-07-18T15:04:33.000Z",
  #                 "updated_at": "2017-07-18T15:07:30.000Z"
  #             },
  #             "admin": {
  #                 "private_profile": {
  #                     "first_name": "Anakin",
  #                     "last_name": "Skywalker",
  #                     "title": "Jedi Knight",
  #                     "email": "anakin@pxp200.com",
  #                     "apikey": "24aec046ddc6c4b13ec725a82721f138"
  #                 }
  #             }
  #         },
  #         {
  #             "public": {
  #                 "title": "Document title 2",
  #                 "description": "This is the description for the second document",
  #                 "file_type": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
  #                 "file_url": "http://s3.amazonaws.com/saltcms-test-setup/uploaders/attachments/000/000/015/original/Field_Work_Center.docx?1500390260",
  #                 "apikey": "95ba26eb6848cdd4c2469a5134e56a82",
  #                 "created_at": "2017-07-18T15:04:21.000Z",
  #                 "updated_at": "2017-07-18T15:04:21.000Z"
  #             },
  #             "admin": {
  #                 "private_profile": {
  #                     "first_name": "Anakin",
  #                     "last_name": "Skywalker",
  #                     "title": "Jedi Knight",
  #                     "email": "anakin@pxp200.com",
  #                     "apikey": "24aec046ddc6c4b13ec725a82721f138"
  #                 }
  #             }
  #         }
  #     ]
  #   }
  def index
    documents = Document.all.sort
    if documents
      render json: {documents: documents}.to_json, status: 200
    else
      render json: {error: "Could not find documents"}.to_json, status: 400
    end
  end

  #
  # Returns a single document.
  #
	# =====Required Params 
  #
	#  apikey
  #
  # =====Request
  #
  #  GET: /api/v1/documents/{{apikey}}
  #
  # =====Response
  #
  #     {
  #         "public": {
  #             "title": "Document title 1",
  #             "description": "This is the description for the first docuemnt ",
  #             "file_type": "application/pdf",
  #             "file_url": "http://s3.amazonaws.com/saltcms-test-setup/uploaders/attachments/000/000/016/original/Hampton_Roads_RFP.pdf?1500390273",
  #             "apikey": "b2000ee2efba79894da7a3167a009d78",
  #             "created_at": "2017-07-18T15:04:33.000Z",
  #             "updated_at": "2017-07-18T15:07:30.000Z"
  #         },
  #         "admin": {
  #             "private_profile": {
  #                 "first_name": "Anakin",
  #                 "last_name": "Skywalker",
  #                 "title": "Jedi Knight",
  #                 "email": "anakin@pxp200.com",
  #                 "apikey": "24aec046ddc6c4b13ec725a82721f138"
  #             }
  #         }
  #     }
  def show
    document = Document.find_by_apikey(params[:id])
    if document
      render json: {document: document}.to_json, status: 200
    else
      render json: {error: "Could not find document"}.to_json, status: 400
    end
  end

  #
  # Creates a Document. 
  #
  # It's important to note that this endpoint does not upload the file. It is only concerned with the URL of the document in question.
  # It will be up to the client side app (Admin) to handle the actual file upload.
  #
	# =====Required Params 
  #
	#  title (unique)
  #  file_url
  #  file_type
  #
	# =====Optional Params 
  #
	#  description
  #
  # =====Request
  #
  #  POST: /api/v1/documents
  #
  # =====Response
  #
  #     {
  #         "public": {
  #             "title": "Document title 1",
  #             "description": "This is the description for the first docuemnt ",
  #             "file_type": "application/pdf",
  #             "file_url": "http://s3.amazonaws.com/saltcms-test-setup/uploaders/attachments/000/000/016/original/Hampton_Roads_RFP.pdf?1500390273",
  #             "apikey": "b2000ee2efba79894da7a3167a009d78",
  #             "created_at": "2017-07-18T15:04:33.000Z",
  #             "updated_at": "2017-07-18T15:07:30.000Z"
  #         },
  #         "admin": {
  #             "private_profile": {
  #                 "first_name": "Anakin",
  #                 "last_name": "Skywalker",
  #                 "title": "Jedi Knight",
  #                 "email": "anakin@pxp200.com",
  #                 "apikey": "24aec046ddc6c4b13ec725a82721f138"
  #             }
  #         }
  #     }
  def create
    document = Document.new(document_params)
    document.admin_id = @current_admin.id
    if document.save
      document.reload
      render json: {document: document}.to_json(include: :tags), status: 200
    else
      render json: {error: document.errors.full_messages.to_sentence}.to_json, status: 400
    end
  end
 
  #
  # Updates a Document. 
  #
  # It's important to note that this endpoint does not upload the file. It is only concerned with the URL of the document in question.
  # It will be up to the client side app (Admin) to handle the actual file upload.
  #
	# =====Required Params 
  #
	#  apikey
  #
	# =====Optional Params 
  #
  #  title
	#  description
  #  file_url
  #  file_type
  #
  # =====Request
  #
  #  PUT: /api/v1/documents/{{apikey}}
  #
  # =====Response
  #
  #     {
  #         "public": {
  #             "title": "Document title 1 WAS UPDATED",
  #             "description": "This is the description for the first docuemnt ",
  #             "file_type": "application/pdf",
  #             "file_url": "http://s3.amazonaws.com/saltcms-test-setup/uploaders/attachments/000/000/016/original/Hampton_Roads_RFP.pdf?1500390273",
  #             "apikey": "b2000ee2efba79894da7a3167a009d78",
  #             "created_at": "2017-07-18T15:04:33.000Z",
  #             "updated_at": "2017-07-18T15:07:30.000Z"
  #         },
  #         "admin": {
  #             "private_profile": {
  #                 "first_name": "Anakin",
  #                 "last_name": "Skywalker",
  #                 "title": "Jedi Knight",
  #                 "email": "anakin@pxp200.com",
  #                 "apikey": "24aec046ddc6c4b13ec725a82721f138"
  #             }
  #         }
  #     }
  def update
    document = Document.find_by_apikey(params[:id])
    if document
      document.assign_attributes(document_params)
      document.save
      render json: {document: document}.to_json, status: 200
    else
      render json: {error: "Document #{params[:id]} not found", status: 400}
    end
  end

  def destroy
  end


  #
  # =====Request
  #
  #  POST: /api/v1/documents/sort
  #
  # =====Required Paramerters
  #
  # You will need to post an array of document apikeys in the order you would like them. For example: 
  #
  #   {"document"=>["b2000ee2efba79894da7a3167a009d78", "95ba26eb6848cdd4c2469a5134e56a82"]}
  # 
  # =====Response
  #
  # [nil]
  #
  def sort
    params[:document].each_with_index {|val, index|
      obj = Document.find_by_apikey(val)
      obj.update_attribute(:sort_order, index)
    }
    render :text => ""
  end


  private

  def document_params
    params.permit(:title, :description, :file_type, :file_url)
  end

end
