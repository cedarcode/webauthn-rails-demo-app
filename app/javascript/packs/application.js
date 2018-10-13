/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

var Turbolinks = require("turbolinks")
Turbolinks.start()

import Rails from 'rails-ujs';
Rails.start()

import { MDCMenu, Corner as MDCMenu_Corner } from '@material/menu';
import { MDCTextField } from '@material/textfield';

document.addEventListener("DOMContentLoaded", function(event) {
  document.querySelectorAll(".mdc-text-field").forEach(function(textfield) {
    new MDCTextField(textfield);
  });

  let menuElement = document.querySelector(".js-menu");
  let menuOpenerElement = document.querySelector(".js-menu-opener");

  if (menuElement && menuOpenerElement) {
    let menu = new MDCMenu(menuElement);

    menuOpenerElement.addEventListener('click', function(event) {
      menu.open = !menu.open;
    });

    menu.setAnchorCorner(MDCMenu_Corner.BOTTOM_START);
  }
});

// Originally in sessions.js
document.addEventListener("DOMContentLoaded", function(event) {
  var sessionForm = document.querySelector("#new-session")

  if (sessionForm) {
    sessionForm.addEventListener("ajax:success", function(event) {
      var [data, status, xhr] = event.detail;
      console.log(data);
      var credentialOptions = data;

      credentialOptions["challenge"] = strToBin(credentialOptions["challenge"]);

      if (credentialOptions["user"]) {
        credentialOptions["user"]["id"] = strToBin(credentialOptions["user"]["id"]);
        var credential_nickname = document.querySelector("#new-session input[name='session[nickname]']").value;
        var callback_url = `/callback?credential_nickname=${credential_nickname}`

        create(encodeURI(callback_url), credentialOptions);
      } else {

        credentialOptions["allowCredentials"].forEach(function(cred, i){
          cred["id"] = strToBin(cred["id"]);
        })

        get(credentialOptions);
      }
    });
  }
});

// Originally in credentials.js
document.addEventListener("DOMContentLoaded", function(event) {
  var addCredential = document.querySelector("#add-credential")

  if (addCredential) {
    addCredential.addEventListener("ajax:success", function(event) {
      var [data, status, xhr] = event.detail;
      var credentialOptions = data;

      credentialOptions["challenge"] = strToBin(credentialOptions["challenge"]);
      credentialOptions["user"]["id"] = strToBin(credentialOptions["user"]["id"]);
      credential_nickname = document.querySelector("#add-credential input[name='credential[nickname]']").value;
      var callback_url = `/credentials/callback?credential_nickname=${credential_nickname}`

      create(encodeURI(callback_url), credentialOptions);
    });
  }
});

function binToStr(bin) {
  return btoa(new Uint8Array(bin).reduce(
    (s, byte) => s + String.fromCharCode(byte), ''
  ));
}

function strToBin(str) {
  console.log(str);
  return Uint8Array.from(atob(str), c => c.charCodeAt(0));
}

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
  navigator.credentials.create({ "publicKey": credentialOptions }).then(function(attestation) {
    callback(callbackUrl, {
      id: attestation.id,
      response: {
        clientDataJSON: binToStr(attestation.response.clientDataJSON),
        attestationObject: binToStr(attestation.response.attestationObject)
      }
    });
  }).catch(function(error) {
    console.log(error);
  });

  console.log("Creating new public key credential...");
}

function get(credentialOptions) {
  navigator.credentials.get({ "publicKey": credentialOptions }).then(function(credential) {
    var assertionResponse = credential.response;

    callback("/callback", {
      id: binToStr(credential.rawId),
      response: {
        clientDataJSON: binToStr(assertionResponse.clientDataJSON),
        signature: binToStr(assertionResponse.signature),
        userHandle: binToStr(assertionResponse.userHandle),
        authenticatorData: binToStr(assertionResponse.authenticatorData)
      }
    });
  }).catch(function(error) {
    console.log(error);
  });

  console.log("Getting public key credential...");
}
