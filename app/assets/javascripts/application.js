// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require material-components-web
//= require turbolinks
//= require_tree .

document.addEventListener("DOMContentLoaded", function(event) {
  document.querySelectorAll(".mdc-text-field").forEach(function(textfield) {
    new window.mdc.textfield.MDCTextField(textfield);
  });

  let menuElement = document.querySelector(".js-menu");
  let menuOpenerElement = document.querySelector(".js-menu-opener");

  if (menuElement && menuOpenerElement) {
    let menu = new window.mdc.menu.MDCMenu(menuElement);

    menuOpenerElement.addEventListener('click', function(event) {
      menu.open = !menu.open;
    });

    menu.setAnchorCorner(window.mdc.menu.Corner.BOTTOM_START);
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
