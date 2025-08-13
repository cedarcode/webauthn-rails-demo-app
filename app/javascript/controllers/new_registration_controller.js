import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hiddenCredentialInput"]

  async create() {
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
        navigator.credentials.create({ publicKey: PublicKeyCredential.parseCreationOptionsFromJSON(data) })
          .then((credential) => {
            console.log("Creating new public key credential...");
            this.hiddenCredentialInputTarget.value = JSON.stringify(credential);
            this.element.submit();
          })
          .catch((error) => alert(error.message || error));

      } else {
        alert(data.errors?.[0] || "Unknown error");
      }
    });
  }
}
