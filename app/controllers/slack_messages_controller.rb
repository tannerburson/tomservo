class SlackMessagesController < ApplicationController
  def message
    result = MessageRouter.route!(params[:payload])

    render plain: result
  end

end
