document.addEventListener("DOMContentLoaded", function(event) {
  var addCredential = document.querySelector("#add-credential")

  if (addCredential) {
    addCredential.addEventListener("ajax:success", function(event) {
      [data, status, xhr] = event.detail;
      var credentialOptions = data;

      credentialOptions["challenge"] = strToBin(credentialOptions["challenge"]);
      credentialOptions["user"]["id"] = strToBin(credentialOptions["user"]["id"]);
      credential_nickname = document.querySelector("#add-credential input[name='credential[nickname]']").value;
      callback_url = `/credentials/callback?credential_nickname=${credential_nickname}`

      create(encodeURI(callback_url), credentialOptions);
    });
  }
});
