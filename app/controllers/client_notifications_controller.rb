class ClientNotificationsController < ApplicationController
  def show
    client = Client.find_by(uuid: params[:client_uuid])
    notification = ClientNotification.find_by(uuid: params[:uuid])

    render json: { client: client, notification: notification }
  end
end

# http://localhost:3000/clients/44d15dbd-d2b8-456b-9c05-a74bc3f72447/notifications/a5371ccd-443e-441d-b9e1-1bce2ce7d1bd

# http://localhost:3000/clients/44d15dbd-d2b8-456b-9c05-a74bc3f72447/portfolio_performances/2021-02-23

# http://localhost:3000/clients/44d15dbd-d2b8-456b-9c05-a74bc3f72447/portfolio_performances/current
