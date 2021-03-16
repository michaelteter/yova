return if NotificationAlert.count > 0

client_ids = Client.all.pluck(:id)

# Single notification for one client
NotificationService.create(
  purpose: 'administrative',
  message: 'Please send the TPS reports.',
  client_ids: [client_ids.first])

# NotificationAlert for multiple clients
NotificationService.create(
  purpose:    'asset_name_update',
  message:    'one or more assets in your portfolio have updated their names',
  client_ids: client_ids.take(client_ids.length / 2)
)

# NotificationAlert for all clients
NotificationService.create(
  purpose:    'portfolio_twr_available',
  message:    'your portfolio time weighted return has been calculated',
  client_ids: client_ids
)
