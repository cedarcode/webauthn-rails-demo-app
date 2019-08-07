import * as Encoder from "encoder";
import * as WebAuthnJSON from "@github/webauthn-json"

function callback(url, body) {
  fetch(url, {
    method: "POST",
    body: JSON.stringify(body),
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content")
    },
    credentials: 'same-origin'
  }).then(function() {
    window.location.replace("/")
  });
}

function create(callbackUrl, credentialOptions) {
  WebAuthnJSON.create({ "publicKey": credentialOptions }).then(function(attestation) {
    callback(callbackUrl, attestation);
  }).catch(function(error) {
    console.log(error);
  });

  console.log("Creating new public key credential...");
}

function get(credentialOptions) {
  WebAuthnJSON.get({ "publicKey": credentialOptions }).then(function(credentials) {
    callback("/session/callback", credentials);
  }).catch(function(error) {
    console.log(error);
  });

  console.log("Getting public key credential...");
}

export { create, get }
