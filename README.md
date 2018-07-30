# WebAuthn Rails Demo App

Application demonstrating a WebAuthn login built with Ruby on Rails.

## Want to try it?

### Option 1 — Visit the hosted version

* Visit https://webauthn.herokuapp.com
* Try loggin in with
  * an email;
  * a [WebAuthn compatible authenticator](https://github.com/cedarcode/webauthn-ruby#a-conforming-authenticator).


### Option 2 — Run it locally

```
$ bundle install
$ yarn install (or npm install)
$ bundle exec rake db:setup
$ bundle exec rails s
```

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
