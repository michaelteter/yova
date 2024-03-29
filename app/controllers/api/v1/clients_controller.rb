module Api
  module V1
    class ClientsController < ApplicationController
      before_action :authenticate_user!

      def show
        client = Client.where(uuid: params[:uuid])
                       .select(%i[name uuid notification_method notification_target public_key])
                       .first

        render json: client
      end
    end
  end
end

