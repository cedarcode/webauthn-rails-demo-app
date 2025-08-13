import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hiddenCredentialInput"]

  async create() {
    const optionsResponse = await fetch("/session/get_options", {
      method: "POST",
      body: new FormData(this.element),
    });

    optionsResponse.json().then((data) => {
      if (optionsResponse.ok) {
        console.log(data);

        navigator.credentials.get({ publicKey: PublicKeyCredential.parseRequestOptionsFromJSON(data) })
          .then((credential) => {
            console.log("Getting public key credential...");
            this.hiddenCredentialInputTarget.value = JSON.stringify(credential);
            this.element.submit();
          })
          .catch((error) => alert(error));
      } else {
        alert(data.errors?.[0] || "Sorry, something wrong happened.");
      }
    });
  }
}
