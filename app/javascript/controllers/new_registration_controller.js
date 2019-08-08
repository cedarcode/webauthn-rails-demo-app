import { Controller } from "stimulus"
import * as Credential from "credential";

import { MDCTextField } from '@material/textfield';

export default class extends Controller {
  static targets = ["usernameField"]

  create(event) {
    var [data, status, xhr] = event.detail;
    console.log(data);
    var credentialOptions = data;

    // Registration
    if (credentialOptions["user"]) {
      var credential_nickname = event.target.querySelector("input[name='registration[nickname]']").value;
      var callback_url = `/registration/callback?credential_nickname=${credential_nickname}`

      Credential.create(encodeURI(callback_url), credentialOptions);
    }
  }

  error(event) {
    let response = event.detail[0];
    let usernameField = new MDCTextField(this.usernameFieldTarget);
    usernameField.valid = false;
    usernameField.helperTextContent = response["errors"][0];
  }
}
