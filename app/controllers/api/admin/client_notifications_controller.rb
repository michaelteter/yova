module Api
  module Admin
    class ClientNotificationsController < ApplicationController
      def index
        notifs = ClientNotificationNotification.all

        render json: notifs
      end

      def show
        notification = ClientNotification.find_by(id: params[:id])

        render json: notification
      end
    end
  end
end

