import { Controller } from "stimulus";
import { supported as WebAuthnSupported } from "@github/webauthn-json";

export default class extends Controller {
  connect() {
    if (!WebAuthnSupported()) {
      this.element.classList.remove("hidden");
    }
  }
}
