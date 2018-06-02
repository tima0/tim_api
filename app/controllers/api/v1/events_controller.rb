class Api::V1::EventsController < ApplicationController

  require 'active_support/core_ext/string/conversions'

  # Secure the controller
  before_filter :admin_token_access

  #
  # Returns a list of all events (active or inactive) sorted by start date/time.
  #
  # =====Optional Params
  #
  #  start:    Provide only events starting after a date/time (inclusive)
  #  end:      Provide only events ending before a date/time (inclusive)
  #  admin_id: Return only events entered by a particular admin (provide Admin ID)
  #  status:   Provide only events that are 'active' or 'inactive'
  #  tag_list: Provide only events that are tagged with all entries in a list of tags ('dog, big')
  #
  # =====Request
  #
  #  GET: /api/v1/events
  #
  # =====Response
  #
	#   {
	#     "events": [
	#         {
	#             "public": {
	#                 "title": "bi-directional",
	#                 "description": "Digitized multimedia website",
	#                 "start_time": "2017-06-12T12:34:59.000Z",
	#                 "end_time": "2017-06-12T12:34:59.000Z",
	#                 "status": "inactive",
	#                 "apikey": "76859f5cf034723f3ba59d9a1f3fa49a",
	#                 "tags": [],
	#                 "cover_image_file_name": null,
	#                 "cover_image_content_type": null,
	#                 "cover_image_file_size": null,
	#                 "cover_image_updated_at": null,
	#                 "created_at": "2017-07-11T22:43:09.000Z",
	#                 "updated_at": "2017-07-11T22:43:09.000Z"
	#             },
	#             "admin": {
	#                 "private_profile": {
	#                     "first_name": "Kylo",
	#                     "last_name": "Ren",
	#                     "title": "Sith",
	#                     "email": "kylo@pxp200.com",
	#                     "apikey": "267781b478ad3c6ed1502473346f781d"
	#                 }
	#             }
	#         },
	#         {
	#             "public": {
	#                 "title": "data-warehouse",
	#                 "description": "Customizable modular hub",
	#                 "start_time": "2017-06-13T05:27:36.000Z",
	#                 "end_time": "2017-06-13T05:27:36.000Z",
	#                 "status": "inactive",
	#                 "apikey": "8800ab7909e7adfc546fb29ec7e1147c",
	#                 "tags": [],
	#                 "cover_image_file_name": null,
	#                 "cover_image_content_type": null,
	#                 "cover_image_file_size": null,
	#                 "cover_image_updated_at": null,
	#                 "created_at": "2017-07-11T22:43:10.000Z",
	#                 "updated_at": "2017-07-11T22:43:10.000Z"
	#             },
	#             "admin": {
	#                 "private_profile": {
	#                     "first_name": "Anakin",
	#                     "last_name": "Skywalker",
	#                     "title": "Jedi Knight",
	#                     "email": "anakin@pxp200.com",
	#                     "apikey": "c2d118a9e8e2cbbbd88e2deb2e27249e"
	#                 }
	#             }
	#         }
	# 	]
	#   }

  def index
    if params[:tag_list]
      # parse the tag input
      tags = params[:tag_list].split(',').map(&:strip)
      events = Event.admin_is(params[:admin_id])
                   .status(params[:status])
                   .start_after(params[:start])
                   .end_before(params[:end])
                   .tagged_with(tags)
                   .order(start_time: :desc)
    else
      events = Event.admin_is(params[:admin_id])
                    .status(params[:status])
                    .start_after(params[:start])
                    .end_before(params[:end])
                    .order(start_time: :desc)
    end
    if events
      render json: {events: events}.to_json(include: :tags), status: 200
    else
      render json: {error: 'Could not find any matching events'}.to_json, status: 400
    end
  end


  # =====Required Params
  #
  #   title (unique)
  #   description
  #   start_time  (any to_datetime compatible string)
  #   end_time    (any to_datetime compatible string)
  # ===== Optional Parameters
  #   status      ("active" or "inactive") Default: "active"
  #   cover_image URL to image
  #   tag_list   String of comma separated tags (white space around commas will be stripped)
  #
  # =====Request
  #
  #  POST: /api/v1/events
  #
  # =====Response
  #
	#   {
	#     "event": {
	#         "public": {
	#             "title": "THIS WAS CREATED",
	#             "description": "EVENT DESCRIPTION",
	#             "start_time": "2017-08-01T00:00:00.000Z",
	#             "end_time": "2017-08-01T00:00:00.000Z",
	#             "status": "active",
	#             "apikey": "9dbd88aff4c06a30a865577b136f1160",
	#             "tags": [],
	#             "cover_image_file_name": null,
	#             "cover_image_content_type": null,
	#             "cover_image_file_size": null,
	#             "cover_image_updated_at": null,
	#             "created_at": "2017-07-11T23:10:39.000Z",
	#             "updated_at": "2017-07-11T23:10:39.000Z"
	#         },
	#         "admin": {
	#             "private_profile": {
	#                 "first_name": "Anakin",
	#                 "last_name": "Skywalker",
	#                 "title": "Jedi Knight",
	#                 "email": "anakin@pxp200.com",
	#                 "apikey": "c2d118a9e8e2cbbbd88e2deb2e27249e"
	#             }
	#         }
	#     }
	#   }
  def create
    # Handle optional status parameter
    params['status'] = 'active' unless params.has_key?('status')

    event = Event.new(event_params)
    event.admin_id = @current_admin.id
    if event.save
      event.reload
      render json: {event: event}.to_json(include: :tags), status: 200
    else
      render json: {error: event.errors.full_messages.to_sentence}.to_json, status: 400
    end
  end

  # =====Required Params
  #
  #   id     id of event record to delete
  #
  # ===== Optional Parameters
  #   none
  #
  # =====Request
  #
  #  DELETE: /api/v1/events
  #
  # =====Response
  #
  # {
  #     "event": {
  #         "id": 32,
  #         "title": "New Event Title",
  #         "description": "A fun thing we can all do",
  #         "start_time": "2017-06-06T00:00:00.000Z",
  #         "end_time": "2017-06-06T00:00:00.000Z",
  #         "status": "active",
  #         "admin_id": 1,
  #         "created_at": "2017-06-04T17:16:52.000Z",
  #         "updated_at": "2017-06-04T17:16:52.000Z",
  #         "cover_image_file_name": null,
  #         "cover_image_content_type": null,
  #         "cover_image_file_size": null,
  #         "cover_image_updated_at": null,
  #         "end_time": "2017-06-06T00:00:00.000Z",
  #         "tags": [
  #           {
  #               "id": 4,
  #               "name": "fish",
  #               "taggings_count": 8
  #           }
  #         ]
  #     }
  # }
  def destroy
    event = Event.find_by_apikey(params[:id])
    if event
      event.delete
      render json: {event: event}.to_json(include: :tags), status: 200
    else
      render json: {error: "Event #{params[:id]} not found", status: 400}
    end
  end


  # =====Required Params
  #
  #   apikey     apikey of event record to get
  #
  # ===== Optional Parameters
  #   none
  #
  # =====Request
  #
  #  GET: /api/v1/events/{{apikey}}
  #
  # =====Response
  #
	#   {
	#     "event": {
	#         "public": {
	#             "title": "data-warehouse",
	#             "description": "Customizable modular hub",
	#             "start_time": "2017-06-13T05:27:36.000Z",
	#             "end_time": "2017-06-13T05:27:36.000Z",
	#             "status": "inactive",
	#             "apikey": "8800ab7909e7adfc546fb29ec7e1147c",
	#             "tags": [],
	#             "cover_image_file_name": null,
	#             "cover_image_content_type": null,
	#             "cover_image_file_size": null,
	#             "cover_image_updated_at": null,
	#             "created_at": "2017-07-11T22:43:10.000Z",
	#             "updated_at": "2017-07-11T22:43:10.000Z"
	#         },
	#         "admin": {
	#             "private_profile": {
	#                 "first_name": "Anakin",
	#                 "last_name": "Skywalker",
	#                 "title": "Jedi Knight",
	#                 "email": "anakin@pxp200.com",
	#                 "apikey": "c2d118a9e8e2cbbbd88e2deb2e27249e"
	#             }
	#         }
	#     }
	#   }

  def show
    event = Event.find_by_apikey(params[:id])
    if event
      render json: {event: event}.to_json(include: :tags), status: 200
    else
      render json: {error: "Event #{params[:id]} not found", status: 400}
    end
  end

  # =====Required Params
  #   apikey           apikey of event record to update
  #
  # ===== Optional Parameters
  #   title
  #   description
  #   start_time   (any to_datetime compatible string)
  #   end_time     (any to_datetime compatible string)
  #   status       ("active" or "inactive") Default: "active"
  #   tag_list     String of comma separated tags (white space around commas will be stripped)
  #
  # =====Request
  #
  #  PATCH: /api/v1/events/{{apikey}}
  #  PUT: /api/v1/events/{{apikey}}
  #
  # =====Response
  #
	#   {
	#     "event": {
	#         "public": {
	#             "title": "THIS WAS CHANGED",
	#             "description": "Customizable modular hub",
	#             "start_time": "2017-06-13T05:27:36.000Z",
	#             "end_time": "2017-06-13T05:27:36.000Z",
	#             "status": "inactive",
	#             "apikey": "8800ab7909e7adfc546fb29ec7e1147c",
	#             "tags": [],
	#             "cover_image_file_name": null,
	#             "cover_image_content_type": null,
	#             "cover_image_file_size": null,
	#             "cover_image_updated_at": null,
	#             "created_at": "2017-07-11T22:43:10.000Z",
	#             "updated_at": "2017-07-11T23:04:45.628Z"
	#         },
	#         "admin": {
	#             "private_profile": {
	#                 "first_name": "Anakin",
	#                 "last_name": "Skywalker",
	#                 "title": "Jedi Knight",
	#                 "email": "anakin@pxp200.com",
	#                 "apikey": "c2d118a9e8e2cbbbd88e2deb2e27249e"
	#             }
	#         }
	#     }
	#   }
  def update
    event = Event.find_by_apikey(params[:id])
    if event
      event.assign_attributes(event_params)
      event.save
      render json: {event: event}.to_json(include: :tags), status: 200
    else
      render json: {error: "Event #{params[:id]} not found", status: 400}
    end
  end

  private

  def event_params
    params.permit(:start_time, :end_time, :title, :description, :status, :cover_image, :tag_list)
  end

end
