import * as WebAuthnJSON from "@github/webauthn-json"

function getCSRFToken() {
  var CSRFSelector = document.querySelector('meta[name="csrf-token"]')
  if (CSRFSelector) {
    return CSRFSelector.getAttribute("content")
  } else {
    return null
  }
}

function showErrorMessage(message) {
  const errorElement = document.querySelector("#error_explanation");

  errorElement.innerHTML = message;
  errorElement.hidden = false;
}

function callback(url, body) {
  fetch(url, {
    method: "POST",
    body: JSON.stringify(body),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-CSRF-Token": getCSRFToken()
    },
    credentials: 'same-origin'
  }).then(function(response) {
    if (response.ok) {
      window.location.replace("/")
    } else if (response.status < 500) {
      response.text().then(showErrorMessage);
    } else {
      showErrorMessage("Sorry, something wrong happened.");
    }
  });
}

function create(callbackUrl, credentialOptions) {
  WebAuthnJSON.create({ "publicKey": credentialOptions }).then(function(credential) {
    callback(callbackUrl, credential);
  }).catch(function(error) {
    showErrorMessage(error);
  });
}

function get(credentialOptions) {
  WebAuthnJSON.get({ "publicKey": credentialOptions }).then(function(credential) {
    callback("/webauthn-rails/session/callback", credential);
  }).catch(function(error) {
    showErrorMessage(error);
  });
}

export { create, get }
