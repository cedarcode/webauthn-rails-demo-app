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

    try {
      const data = await optionsResponse.json();
      console.log(data);

      if (optionsResponse.ok && data.user) {
        console.log("Creating new public key credential...");

        const credential = await navigator.credentials.create({ publicKey: PublicKeyCredential.parseCreationOptionsFromJSON(data) });
        this.hiddenCredentialInputTarget.value = JSON.stringify(credential);
        this.element.submit();
      } else {
        alert(data.errors?.[0] || "Sorry, something wrong happened.");
      }
    } catch (error) {
      alert(error.message || error);
    }
  }
}
