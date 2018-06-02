class Api::V1::ActivitiesController < ApplicationController

  before_filter :admin_token_access

  #
  # Returns a list of all logged activity in the last 7 days
  #
  # =====Request
  #
  #  GET: /api/v1/activities
  #
  # =====Response
  #
  #   {
  #     "activities": [
  #         {
  #             "activity": "Create this!! MOD AGAIN was updated in news by Anakin Skywalker",
  #             "created_at": "2017-07-15T04:47:48.000Z",
  #         },
  #         {
  #             "activity": "Create this!! MOD was updated in news by Anakin Skywalker",
  #             "created_at": "2017-07-15T04:47:39.000Z",
  #         }
  #       [
  #   }
  def index
    activities = ActivityLog.last_7.order(created_at: :desc)
    if activities
      render json: {activities: activities}.to_json, status: 200
    else
      render json: {error: "Could not find activities"}.to_json, status: 400
    end
  end

end
