import { Controller } from "stimulus"
import * as Credential from "credential";
import * as Encoder from "encoder";

export default class extends Controller {
  create(event) {
    var [data, status, xhr] = event.detail;
    console.log(data);
    var credentialOptions = data;

    credentialOptions["challenge"] = Encoder.strToBin(credentialOptions["challenge"]);
    // Registration
    if (credentialOptions["user"]) {
      credentialOptions["user"]["id"] = Encoder.strToBin(credentialOptions["user"]["id"]);
      var credential_nickname = event.target.querySelector("input[name='registration[nickname]']").value;
      var callback_url = `/registration/callback?credential_nickname=${credential_nickname}`

      Credential.create(encodeURI(callback_url), credentialOptions);
    }
  }
}
