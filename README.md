# WebAuthn Rails Demo App

Application demonstrating a [WebAuthn](https://en.wikipedia.org/wiki/WebAuthn) password-less login built with Ruby on Rails + [webauthn](https://github.com/cedarcode/webauthn-ruby) ruby gem.

[![Travis](https://img.shields.io/travis/cedarcode/webauthn-rails-demo-app/master.svg?style=flat-square)](https://travis-ci.org/cedarcode/webauthn-rails-demo-app)

## Want to try it?

### Option 1 — Visit the hosted version

* Visit https://webauthn.cedarcode.com
* Try logging in with
  * a username;
  * a [WebAuthn compatible authenticator](https://github.com/cedarcode/webauthn-ruby#prerequisites).


### Option 2 — Run it locally

#### Prerequisites

* Ruby
* yarn (or npm)
* PostgreSQL

#### Setup

```
$ git clone https://github.com/cedarcode/webauthn-rails-demo-app
$ cd webauthn-rails-demo-app/
$ cp .env.example .env
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

### Gem Update Policy

#### Gemfile Version Constraints

In `Gemfile` define gem dependencies using a version contrainst of `~> MAJOR.MINOR` by default (or ~> `0.MINOR.PATCH` if
latest `MAJOR` is `0`), unless you have reasons to use something different. An example of an exception could be
`rails`, which is known to make backwards-incompatible changes in minor level updates, so in that case we use
`~> MAJOR.MINOR.PATCH`.

#### Updating

```
$ gem install bundler-audit
$ bundle audit --update
$ bundle update --conservative --group test development
$ bundle update --strict --patch
$ bundle update --strict --minor
$ bundle update --major
$ bundle outdated --groups
```

More in:

[Updating gems cheat sheet](https://medium.com/cedarcode/updating-gems-cheat-sheet-346d5666a181)
