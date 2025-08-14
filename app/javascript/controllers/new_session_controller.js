import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hiddenCredentialInput"]

  async create() {
    const optionsResponse = await fetch("/session/get_options", {
      method: "POST",
      body: new FormData(this.element),
    });

    try {
      const data = await optionsResponse.json();
      console.log(data);

      if (optionsResponse.ok) {
        console.log("Getting public key credential...");

        const credential = await navigator.credentials.get({ publicKey: PublicKeyCredential.parseRequestOptionsFromJSON(data) })
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
