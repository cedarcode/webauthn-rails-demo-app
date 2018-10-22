import { Controller } from "stimulus"
import * as Credential from "credential";
import * as Encoder from "encoder";

export default class extends Controller {
  create(event) {
    var [data, status, xhr] = event.detail;
    console.log(data);
    var credentialOptions = data;
    credentialOptions["challenge"] = Encoder.strToBin(credentialOptions["challenge"]);
    credentialOptions["allowCredentials"].forEach(function(cred, i){
      cred["id"] = Encoder.strToBin(cred["id"]);
    })
    Credential.get(credentialOptions);
  }
}
