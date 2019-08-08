import { Controller } from "stimulus"
import * as Credential from "credential";

export default class extends Controller {
  create(event) {
    var [data, status, xhr] = event.detail;
    var credentialOptions = data;
    var credential_nickname = event.target.querySelector("input[name='credential[nickname]']").value;
    var callback_url = `/credentials/callback?credential_nickname=${credential_nickname}`

    Credential.create(encodeURI(callback_url), credentialOptions);
  }
}
