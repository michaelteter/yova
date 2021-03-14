SAMPLE_CLIENT_COUNT = 10

new_client_count = SAMPLE_CLIENT_COUNT - Client.count

new_client_count.times { FactoryBot.create(:client) }

