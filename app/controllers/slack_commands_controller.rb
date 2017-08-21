class SlackCommandsController < ApplicationController

  def slack_params
    params.permit(:token,:team_id,:team_domain,:channel_id,:channel_name,:user_id,:user_name,:command,:text,:response_url,:trigger_id)
  end

  def update
    result = CommandRouter.route!(slack_params)

    render json: result

  end
end
