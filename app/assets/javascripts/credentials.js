document.addEventListener("DOMContentLoaded", function(event) {
  var addCredential = document.querySelector("#add-credential")

  if (addCredential) {
    addCredential.addEventListener("ajax:success", function(event) {
      [data, status, xhr] = event.detail;
      var credentialOptions = data;

      credentialOptions["challenge"] = strToBin(credentialOptions["challenge"]);
      credentialOptions["user"]["id"] = strToBin(credentialOptions["user"]["id"]);

      create(`/users/${credentialOptions["user_id"]}/credentials/callback`, credentialOptions);
    });
  }
});
