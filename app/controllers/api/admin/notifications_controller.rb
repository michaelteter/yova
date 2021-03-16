module Api
  module Admin
    class NotificationsController < ApplicationController
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
          NotificationAdminService.create_and_alert_clients(params.permit(%i[purpose message client_ids]))

        status, data = if notification_alert_id
                         [{ notification_alert_id: notification_alert_id }, 201]
                       else
                         [{ error: 'creation failed' }, 500]
                       end

        render json: data, status: status
      end
    end
  end
end
