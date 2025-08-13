import { Controller } from "@hotwired/stimulus"
import { showMessage } from "messenger";

export default class extends Controller {
  async create(event) {
    const optionsResponse = await fetch("/credentials/create_options", {
      method: "POST",
      body: new FormData(this.element),
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.getAttribute("content")
      }
    });

    optionsResponse.json().then((data) => {
      console.log(data);

      if (optionsResponse.ok) {
        const credential_nickname = event.target.querySelector("input[name='credential[nickname]']").value || "";
        const callbackUrl = `/credentials?credential_nickname=${credential_nickname}`

        navigator.credentials.create({ publicKey: PublicKeyCredential.parseCreationOptionsFromJSON(data) })
          .then((credential) => this.#submitCredential(encodeURI(callbackUrl), credential))
          .catch((error) => alert(error));
      } else {
        alert(data.errors?.[0] || "Unknown error");
      }
    });
    console.log("Creating new public key credential...");
  }

  #submitCredential(url, credential) {
    fetch(url, {
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
