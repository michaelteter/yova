module Api
  module Admin
    class NotificationsController < ApplicationController
      def index
        notifs = Notification.all

        render json: notifs.to_json(include: :client_notifications)
      end
    end
  end
end
