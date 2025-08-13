import { Controller } from "@hotwired/stimulus"
import { showMessage } from "messenger";

export default class extends Controller {
  async create(event) {
    const optionsResponse = await fetch("/registration/create_options", {
      method: "POST",
      body: new FormData(this.element),
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.getAttribute("content")
      }
    });

    optionsResponse.json().then((data) => {
      console.log(data);

      if (optionsResponse.ok && data.user) {
        const credential_nickname = event.target.querySelector("input[name='registration[nickname]']")?.value || "";
        const registrationUrl = `/registration?credential_nickname=${credential_nickname}`;

        navigator.credentials.create({ publicKey: PublicKeyCredential.parseCreationOptionsFromJSON(data) })
          .then((credential) => this.#submitRegistration(encodeURI(registrationUrl), credential))
          .catch((error) => alert(error.message || error));

        console.log("Creating new public key credential...");
      } else {
        alert(data.errors?.[0] || "Unknown error");
      }
    });
  }

  #submitRegistration(url, credential) {
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
