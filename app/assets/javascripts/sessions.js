document.addEventListener("DOMContentLoaded", function(event) {
  var sessionForm = document.querySelector("#new-session")

  if (sessionForm) {
    sessionForm.addEventListener("ajax:success", function(event) {
      [data, status, xhr] = event.detail;
      console.log(data);
      var credentialOptions = data;

      credentialOptions["challenge"] = strToBin(credentialOptions["challenge"]);

      if (credentialOptions["user"]) {
        credentialOptions["user"]["id"] = strToBin(credentialOptions["user"]["id"]);

        create("/callback", credentialOptions);
      } else {

        credentialOptions["allowCredentials"].forEach(function(cred, i){
          cred["id"] = strToBin(cred["id"]);
        })

        get(credentialOptions);
      }
    });
  }
});
