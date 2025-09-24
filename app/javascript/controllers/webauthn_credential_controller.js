import { Controller } from "@hotwired/stimulus"
import { showMessage } from "messenger";

export default class extends Controller {
  static targets = ["hiddenCredentialInput", "submitButton"]
  static values = { optionsUrl: String, submitUrl: String }

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

        const submitResponse = await fetch(this.submitUrlValue, {
          method: "POST",
          body: new FormData(this.element),
        });

        const submitResponseJson = await submitResponse.json();

        const { redirect_to } = submitResponseJson;

        window.location.replace(redirect_to || "/");
      } else {
        showMessage(credentialOptionsJson.errors?.[0] || "Sorry, something wrong happened.");
        this.submitButtonTarget.disabled = false;
      }
    } catch (error) {
      showMessage(error.message || "Sorry, something wrong happened.");
      this.submitButtonTarget.disabled = false;
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

        const submitResponse = await fetch(this.submitUrlValue, {
          method: "POST",
          body: new FormData(this.element),
        });

        const submitResponseJson = await submitResponse.json();

        const { redirect_to } = submitResponseJson;

        window.location.replace(redirect_to || "/");
      } else {
        showMessage(credentialOptionsJson.errors?.[0] || "Sorry, something wrong happened.");
        this.submitButtonTarget.disabled = false;
      }
    } catch (error) {
      showMessage(error.message || "Sorry, something wrong happened.");
      this.submitButtonTarget.disabled = false;
    }
  }
}
