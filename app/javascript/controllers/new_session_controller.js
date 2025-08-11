import { Controller } from "@hotwired/stimulus"
import { showMessage } from "messenger";

import { MDCTextField } from '@material/textfield';

export default class extends Controller {
  static targets = ["usernameField"]

  create(event) {
    var [data, status, xhr] = event.detail;
    console.log(data);
    const credentialOptions = PublicKeyCredential.parseRequestOptionsFromJSON(data);

    navigator.credentials.get({ "publicKey": credentialOptions })
      .then((credential) => this.#submitSession("/session/callback", credential))
      .catch((error) => showMessage(error));

    console.log("Getting public key credential...");
  }

  error(event) {
    let response = event.detail[0];
    let usernameField = new MDCTextField(this.usernameFieldTarget);
    usernameField.valid = false;
    usernameField.helperTextContent = response["errors"][0];
  }

  #submitSession(url, credential) {
    fetch(url, {
      method: "POST",
      body: JSON.stringify(credential),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.getAttribute("content")
      },
      credentials: 'same-origin'
    }).then(function(response) {
      if (response.ok) {
        window.location.replace("/")
      } else if (response.status < 500) {
          response.text().then(showMessage);
      } else {
        showMessage("Sorry, something wrong happened.");
      }
    });

  }
}
