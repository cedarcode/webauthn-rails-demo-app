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
//= require activestorage
//= require turbolinks
//= require_tree .

function binToStr(bin) {
  return btoa(new Uint8Array(bin).reduce(
    (s, byte) => s + String.fromCharCode(byte), ''
  ));
}

function strToBin(str) {
  console.log(str);
  return Uint8Array.from(atob(str), c => c.charCodeAt(0));
}

document.addEventListener("DOMContentLoaded", function(event) {
  var sessionForm = document.querySelector("#new-session")

  if (sessionForm) {
    sessionForm.addEventListener("ajax:success", function(event) {
      [data, status, xhr] = event.detail;
      console.log(data);
      var credentialCreationOptions = data;

      credentialCreationOptions["challenge"] = strToBin(credentialCreationOptions["challenge"]);
      credentialCreationOptions["user"]["id"] = strToBin(credentialCreationOptions["user"]["id"]);

      navigator.credentials.create({ "publicKey": credentialCreationOptions }).then(function(attestation) {
        console.log("Success");

        fetch("/callback", {
          method: "POST",
          body: JSON.stringify({
            id: attestation.id,
            response: {
              clientDataJSON: binToStr(attestation.response.clientDataJSON),
              attestationObject: binToStr(attestation.response.attestationObject)
            }
          }),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content")
          },
          credentials: 'same-origin'
        }).then(function() {
          window.location.replace("/")
        });
      }).catch(function(error) {
        console.log("Failure");
        console.log(error);
      });

      console.log("Creating new public key credential...");
    });
  }
});
