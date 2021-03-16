module Api
  module V1
    class ClientNotificationsController < ApplicationController
      def show
        client = Client.find_by(uuid: params[:client_uuid])
        notification = Notification.find_by(uuid: params[:uuid])

        notification.update(fetched_at: DateTime.now)

        render json: notification
      end
    end
  end
end

