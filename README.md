# WebAuthn Rails Demo App

Application demonstrating a WebAuthn login built with Ruby on Rails.

[![Travis](https://img.shields.io/travis/cedarcode/webauthn-rails-demo-app/master.svg?style=flat-square)](https://travis-ci.org/cedarcode/webauthn-rails-demo-app)

## Want to try it?

### Option 1 — Visit the hosted version

* Visit https://webauthn.herokuapp.com
* Try loggin in with
  * a username;
  * a [WebAuthn compatible authenticator](https://github.com/cedarcode/webauthn-ruby#a-conforming-authenticator).


### Option 2 — Run it locally

#### Prerequisites

* Ruby
* yarn (or npm)
* PostgreSQL

#### Setup

```
$ git clone https://github.com/cedarcode/webauthn-rails-demo-app
$ cd webauthn-rails-demo-app/
$ bundle install
$ yarn install (or npm install)
$ bundle exec rake db:setup
```

#### Running

```
$ bundle exec rails s
```

Now you can visit http://localhost:3000 to play with the demo site.

## Development

### Updating gems

```
$ gem install bundler-audit
$ bundle audit --update
$ bundle update --conservative --group test development
$ bundle update --patch --strict
$ bundle update --minor --strict
$ bundle update --major
$ bundle outdated
```
