import { Controller } from "@hotwired/stimulus"
import { showMessage } from "messenger";

export default class extends Controller {
  async create() {
    const optionsResponse = await fetch("/session/get_options", {
      method: "POST",
      body: new FormData(this.element),
    });

    optionsResponse.json().then((data) => {
      if (optionsResponse.ok) {
        console.log(data);

        navigator.credentials.get({ publicKey: PublicKeyCredential.parseRequestOptionsFromJSON(data) })
          .then((credential) => this.#submitSession(credential))
          .catch((error) => alert(error));

        console.log("Getting public key credential...");
      } else {
        alert(data.errors?.[0] || "Unknown error");
      }
    });
  }

  #submitSession(credential) {
    fetch(this.element.action, {
      method: this.element.method,
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
