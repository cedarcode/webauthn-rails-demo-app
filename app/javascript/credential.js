import * as WebAuthnJSON from "@github/webauthn-json"

import { showMessage } from "messenger";

function getCSRFToken() {
  var CSRFSelector = document.querySelector('meta[name="csrf-token"]')
  if (CSRFSelector) {
    return CSRFSelector.getAttribute("content")
  } else {
    return null
  }
}

function _fetch(url, body) {
  return fetch(url, {
    method: "POST",
    body: JSON.stringify(body),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-CSRF-Token": getCSRFToken()
    },
    credentials: 'same-origin'
  })
}

function callback(url, body) {
  _fetch(url, body).then(function(response) {
    if (response.ok) {
      window.location.replace("/")
    } else if (response.status < 500) {
      response.text().then(showMessage);
    } else {
      showMessage("Sorry, something wrong happened.");
    }
  });
}

function getCredentialOptions() {
  return _fetch("/session/options").then(function(response) {
    if (response.ok) {
      return response.json();
    }
    if (response.status < 500) {
      response.text().then(showMessage);
    } else {
      showMessage("Sorry, something wrong happened.");
    }
  });
}

async function autofill() {
  if (WebAuthnJSON.supported &&
    PublicKeyCredential.isConditionalMediationAvailable) {
      try {
        const cma = await PublicKeyCredential.isConditionalMediationAvailable();
        if (cma) {
          var credentialOptions = await getCredentialOptions();
          get(credentialOptions, "conditional");
        }
      } catch (e) {
        console.error(e);
        if (e.name !== "NotAllowedError") {
          alert(e.message);
        }
      }
  }
}

function create(callbackUrl, credentialOptions) {
  WebAuthnJSON.create({ "publicKey": credentialOptions }).then(function(credential) {
    callback(callbackUrl, credential);
  }).catch(function(error) {
    showMessage(error);
  });

  console.log("Creating new public key credential...");
}

function get(credentialOptions, mediationOption) {
  WebAuthnJSON.get({ "publicKey": credentialOptions, "mediation": mediationOption }).then(function(credential) {
    callback("/session/callback", credential);
  }).catch(function(error) {
    showMessage(error);
  });

  console.log("Getting public key credential...");
}

export { autofill, create, get }
