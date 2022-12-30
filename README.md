# Ad Hoc WebAuthn Demo

Application demonstrating a [WebAuthn](https://en.wikipedia.org/wiki/WebAuthn) password-less login built with Ruby on Rails + [webauthn](https://github.com/cedarcode/webauthn-ruby) ruby gem. This repository was forked from [cedarcode/webauthn-rails-demo-app](https://github.com/cedarcode/webauthn-rails-demo-app) and customized to fit Ad Hoc's needs.

## Want to try it?

### Prerequisites

* Ruby 3.1.0
* Node 16
* Yarn >= v1.7.0
* PostgreSQL
* Docker (Only for running using Docker)

### Option 1 — Run it locally

#### Local Setup

```bash
git clone https://github.com/adhocteam/webauthn-rails-demo-app
cd webauthn-rails-demo-app/
cp .env.example .env
bundle install
yarn install (or npm install)
bundle exec rake db:setup
```

#### Running

```bash
bundle exec rails s
```

Now you can visit http://localhost:3000 to play with the demo site.

### Option 2 — Run it with Docker

#### Prerequisites

* Docker (Docker compose)

#### Docker Setup

```bash
git clone https://github.com/adhocteam/webauthn-rails-demo-app
cd webauthn-rails-demo-app/
cp .env.example .env
docker compose build
docker compose run web scripts/wait-for-it.sh db:5432 -- "rails db:setup"
docker compose up
```
