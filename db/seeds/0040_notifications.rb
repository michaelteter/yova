return if Notification.count > 0

# Single notification for one client
client = Client.last
NotificationAdminService.create_notification(
  purpose:    'new_client_welcome',
  message:    "Yova is pleased to be partners with #{client.name}.",
  client_ids: [Client.last.id]
)

client_ids = Client.all.pluck(:id)

selected_client_id_indices = Util.distinct_rand_ints(n_ints: 3, max_int: client_ids.count - 1)
selected_client_ids = selected_client_id_indices.map { |i| client_ids[i] }
# Notification for multiple clients
NotificationAdminService.create_notification(
  purpose:    'asset_name_update',
  message:    'one or more assets in your portfolio have updated their names',
  client_ids: selected_client_ids
)

# Notification for all clients
NotificationAdminService.create_notification(
  purpose:    'portfolio_twr_available',
  message:    'your portfolio time weighted return has been calculated',
  client_ids: client_ids
)
