import { Controller } from "stimulus"
import * as Credential from "credential";
import * as Encoder from "encoder";

export default class extends Controller {
  create(event) {
    var [data, status, xhr] = event.detail;
    console.log(data);
    var credentialOptions = data;

    credentialOptions["challenge"] = Encoder.strToBin(credentialOptions["challenge"]);

    if (credentialOptions["user"]) {
      credentialOptions["user"]["id"] = Encoder.strToBin(credentialOptions["user"]["id"]);
      var credential_nickname = event.target.querySelector("input[name='session[nickname]']").value;
      var callback_url = `/callback?credential_nickname=${credential_nickname}`

      Credential.create(encodeURI(callback_url), credentialOptions);
    } else {
      credentialOptions["allowCredentials"].forEach(function(cred, i){
        cred["id"] = Encoder.strToBin(cred["id"]);
      })

      Credential.get(credentialOptions);
    }
  }
}
