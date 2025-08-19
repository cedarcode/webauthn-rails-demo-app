import { Controller } from "@hotwired/stimulus"
import { showMessage } from "messenger";

export default class extends Controller {
  static targets = ["hiddenCredentialInput"]
  static values = { optionsUrl: String }

  async create() {
    try {
      const response = await fetch(this.optionsUrlValue, {
        method: "POST",
        body: new FormData(this.element),
      });

      const credentialOptionsJson = await response.json();
      console.log(credentialOptionsJson);

      if (response.ok) {
        console.log("Creating new public key credential...");

        const credential = await navigator.credentials.create({ publicKey: PublicKeyCredential.parseCreationOptionsFromJSON(credentialOptionsJson) });
        this.hiddenCredentialInputTarget.value = JSON.stringify(credential);
        this.element.submit();
      } else {
        showMessage(credentialOptionsJson.errors?.[0] || "Sorry, something wrong happened.");
      }
    } catch (error) {
      showMessage(error.message || "Sorry, something wrong happened.");
    }
  }

  async get() {
    try {
      const response = await fetch(this.optionsUrlValue, {
        method: "POST",
        body: new FormData(this.element),
      });

      const credentialOptionsJson = await response.json();
      console.log(credentialOptionsJson);

      if (response.ok) {
        console.log("Getting public key credential...");

        const credential = await navigator.credentials.get({ publicKey: PublicKeyCredential.parseRequestOptionsFromJSON(credentialOptionsJson) })
        this.hiddenCredentialInputTarget.value = JSON.stringify(credential);
        this.element.submit();
      } else {
        showMessage(credentialOptionsJson.errors?.[0] || "Sorry, something wrong happened.");
      }
    } catch (error) {
      showMessage(error.message || "Sorry, something wrong happened.");
    }
  }
}
