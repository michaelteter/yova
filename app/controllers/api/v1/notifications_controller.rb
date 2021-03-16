module Api
  module V1
    class NotificationsController < ApplicationController
      def index
        return unless client = load_client

        notifs = client.notifications

        h = {}

        notifs.each do |n|
          h[n.uuid] = {
            date: n.created_at,
            alerted_at: n.notified_at,
            read_at: n.fetched_at,
            resource: "/api/v1/clients/#{client.uuid}/notifications/#{n.uuid}"
          }
        end

        render json: h
      end

      def show
        return unless client = load_client

        n = Notification.find_by(uuid: params[:uuid])
        n.update(fetched_at: DateTime.now)

        na = n.notification_alert
        h = {
          purpose: na.purpose,
          message: na.message,
          alerted_at: n.notified_at,
          read_at: n.fetched_at,
          created_at: n.created_at,
          resource: "/api/v1/clients/#{client.uuid}/notifications/#{n.uuid}"
        }

        render json: h
      end

      private

      def load_client
        client = Client.find_by(uuid: params[:client_uuid])
        render json: nil, status: 404 and return unless client

        client
      end
    end
  end
end

