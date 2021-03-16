module Api
  module Admin
    class NotificationsController < ApplicationController
      before_action :authenticate_user!

      protect_from_forgery with: :null_session

      def index
        notif_alerts = NotificationAlert.all

        render json: notif_alerts.to_json(include: :notifications)
      end

      def show
        na = NotificationAlert.find_by(id: params[:id])

        render json: na.to_json(include: :notifications)
      end

      def create
        # gather notification details
        # data = params.require(
        # create notification_alert
        # create notifications for every client in target list
        # launch notification_alert job

        notification_alert_id =
          NotificationService.create_and_alert_clients(params.permit(:purpose, :message, client_ids: []))

        data, status =
          if notification_alert_id
            [{ notification_alert_id: notification_alert_id }, :created]
          else
            [{ error: 'creation failed' }, :unprocessable_entity]
          end

        render json: data, status: status
      end
    end
  end
end
