# Yova B2B Portfolio Performance API Demo

*Demonstration system which provides client notifications and portfolio performance 
information to business partners via an API*

## System Setup

Clone the project:

```bash
git clone git@github.com:michaelteter/yova.git

cd yova
```

Setup the environment

```bash
make install
```

Gather timeseries data: 
1. update Note that this process takes some times
bundle exec rails db:seed
```

To run background jobs, ensure Redis and Sidekiq are running

## Start Server and Services

`bundle exec rails s`

`bundle exec sidekiq`

## Sidekiq

View [Sidekiq status and cron jobs](http://localhost:3000/_sidekiq) at 
`http://localhost:3000/_sidekiq`


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
