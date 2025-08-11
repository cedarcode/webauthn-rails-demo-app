import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["message"]

  connect() {
    PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable().then((available) => {
      if (!available) {
        this.messageTarget.innerHTML = "We couldn't detect a user-verifying platform authenticator";
        this.element.classList.remove("hidden");
      }
    });
  }
}
