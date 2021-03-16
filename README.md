# Yova B2B Portfolio Performance API Demo

*Demonstration system which provides client notifications and portfolio performance 
information to business partners via an API*

## System Setup

### Clone the project

```bash
git clone git@github.com:michaelteter/yova.git; cd yova
```

### Setup the environment

```bash
make install
```

### Seed the database

Seeding will populate a reasonable set of sample data, including real companies and timeseries.

The Nasdaq 100 (102!) list comprises the Company data, and Alphavantage is used to pull corresponding
data.  

Data has already been pulled and stored in json files under `app_root/data/historical_timeseries`.
There is currently no logic in place to fetch and append newer timeseries, so the seeder will
just load the existing file rather than fetch from Alphavantage.  Therefore, to demonstrate the 
Alphavantage fetch, one or more timeseries data files must be deleted.

To fetch from Alphavantage requires an API key which they provide.  This key must be saved in
`app_root/alphavantage`, or it can be passed as an environment variable `ALPHAVANTAGE_KEY`.

Note that the Alphavantage step takes about 25 minutes to load 102 symbol timeseries.

In general, successive calls to db:seed will skip sections where data already exists.
It is safe to call `db:seed` multiple times.

```bash
bundle exec rails db:seed
```

### Start Server and Services

To run background jobs, ensure Redis and Sidekiq are running

```bash
bundle exec sidekiq
```

#### Sidekiq

View [Sidekiq status and cron jobs](http://localhost:3000/_sidekiq) at 
`http://localhost:3000/_sidekiq`

## Running/Testing

```bash
bundle exec rails s
```

### Authentication

To run without JWT, set `DISABLE_JWT` environment variable before running Rails.  This will only apply
when Rails is in development mode.  By default, JWT will be enabled.

All endpoints require authentication except `/_sidekiq` (which obviously needs it, but that's for another time)
and `/api/v1/authenticate`

#### Getting a JWT Token

```bash
curl --request POST \
  --url http://localhost:3000/api/v1/authenticate \
  --header 'content-type: application/json' \
  --data '{
	"username": "1abc34aa-da82-4bc5-97f7-8a0d12537fe2",
	"password": "password123"
}'
```

Usernames and passwords are not stored; for this demo, the "username" should be a UUID.  
Password must be present but is not used.  Anything resembling a UUID and password will work.

With that token, form the other API requests with header bearer entry.

#### Admin API

Show All Notifications
![Show All Notifications](data/screenshots/admin_notifications_index.png "Show All Notification")

```bash
curl --request GET \
  --url http://localhost:3000/api/admin/notifications/7 \
  --header 'authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX3V1aWQiOiIxYWJjMzRhYS1kYTgyLTRiYzUtOTdmNy04YTBkMTI1MzdmZTIifQ.nZ6zuxdD0_sUo90CfgZT0KRht-4p9SaEFhPS5PAb4t4'
```

Create a Notification
![Create a Notification](data/screenshots/admin_create_notification.png "Create a Notification") 

```bash
curl --request POST \
  --url http://localhost:3000/api/admin/notifications \
  --header 'authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX3V1aWQiOiIxYWJjMzRhYS1kYTgyLTRiYzUtOTdmNy04YTBkMTI1MzdmZTIifQ.nZ6zuxdD0_sUo90CfgZT0KRht-4p9SaEFhPS5PAb4t4' \
  --header 'content-type: application/json' \
  --data '{
	"purpose": "test2",
	"message": "This is the second admin post test",
	"client_ids": [
		1,5,7
	]
}'
```

#### Client API

Show a Notification
![Show a Notification](data/screenshots/client_show_notification_detail.png "Show a Notification")

```bash
curl --request GET \
  --url http://localhost:3000/api/v1/clients/1abc34aa-da82-4bc5-97f7-8a0d12537fe2/notifications/99588c8a-dc91-4a91-80a0-6bbee41518c4 \
  --header 'authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX3V1aWQiOiIxYWJjMzRhYS1kYTgyLTRiYzUtOTdmNy04YTBkMTI1MzdmZTIifQ.nZ6zuxdD0_sUo90CfgZT0KRht-4p9SaEFhPS5PAb4t4'
```

List All Notification Alerts (without the content; that should be retrieved via example above)
![List All Notification Alerts](data/screenshots/client_show_notification_alerts.png "List All Notification Alerts")


```bash
curl --request GET \
  --url http://localhost:3000/api/v1/clients/1abc34aa-da82-4bc5-97f7-8a0d12537fe2/notifications \
  --header 'authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX3V1aWQiOiIxYWJjMzRhYS1kYTgyLTRiYzUtOTdmNy04YTBkMTI1MzdmZTIifQ.nZ6zuxdD0_sUo90CfgZT0KRht-4p9SaEFhPS5PAb4t4'
```

Show the Portfolio - TWR calculations and list of all companies in portfolio
![Show the Portfolio](data/screenshots/client_view_portfolio.png "Show the Portfolio")

```bash
curl --request GET \
  --url http://localhost:3000/api/v1/clients/1abc34aa-da82-4bc5-97f7-8a0d12537fe2/portfolio \
  --header 'authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX3V1aWQiOiIxYWJjMzRhYS1kYTgyLTRiYzUtOTdmNy04YTBkMTI1MzdmZTIifQ.nZ6zuxdD0_sUo90CfgZT0KRht-4p9SaEFhPS5PAb4t4'
```
