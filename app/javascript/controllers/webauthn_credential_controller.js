import { Controller } from "@hotwired/stimulus"
import { showMessage } from "messenger";

export default class extends Controller {
  static targets = ["hiddenCredentialInput"]
  static values = { optionsUrl: String }

  async create() {
    try {
      const optionsResponse = await fetch(this.optionsUrlValue, {
        method: "POST",
        body: new FormData(this.element),
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.getAttribute("content")
        }
      });

      const optionsJson = await optionsResponse.json();
      console.log(optionsJson);

      if (optionsResponse.ok) {
        console.log("Creating new public key credential...");

        const credential = await navigator.credentials.create({ publicKey: PublicKeyCredential.parseCreationOptionsFromJSON(optionsJson) });
        this.hiddenCredentialInputTarget.value = JSON.stringify(credential);
        this.element.submit();
      } else {
        showMessage(optionsJson.errors?.[0] || "Sorry, something wrong happened.");
      }
    } catch (error) {
      showMessage(error.message || "Sorry, something wrong happened.");
    }
  }

  async get() {
    try {
      const optionsResponse = await fetch(this.optionsUrlValue, {
        method: "POST",
        body: new FormData(this.element),
        headers: {
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]')?.getAttribute("content")
        }
      });

      const optionsJson = await optionsResponse.json();
      console.log(optionsJson);

      if (optionsResponse.ok) {
        console.log("Getting public key credential...");

        const credential = await navigator.credentials.get({ publicKey: PublicKeyCredential.parseRequestOptionsFromJSON(optionsJson) })
        this.hiddenCredentialInputTarget.value = JSON.stringify(credential);
        this.element.submit();
      } else {
        showMessage(optionsJson.errors?.[0] || "Sorry, something wrong happened.");
      }
    } catch (error) {
      showMessage(error.message || "Sorry, something wrong happened.");
    }
  }
}
