import { Controller } from "@hotwired/stimulus"
import { showMessage } from "messenger";

export default class extends Controller {
  create(event) {
    var [data, status, xhr] = event.detail;
    var credential_nickname = event.target.querySelector("input[name='credential[nickname]']").value;
    var callback_url = `/credentials/callback?credential_nickname=${credential_nickname}`

    const credentialOptions = PublicKeyCredential.parseCreationOptionsFromJSON(data);

      navigator.credentials.create({ "publicKey": credentialOptions })
        .then((credential) => this.#submitCredential(encodeURI(callback_url), credential))
        .catch(function(error) {
          showMessage(error);
        });

      console.log("Creating new public key credential...");
  }

  #submitCredential(url, credential) {
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
