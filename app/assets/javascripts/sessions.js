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
        credential_nickname = document.querySelector("#new-session input[name='session[nickname]']").value;
        callback_url = `/callback?credential_nickname=${credential_nickname}`

        create(encodeURI(callback_url), credentialOptions);
      } else {

        credentialOptions["allowCredentials"].forEach(function(cred, i){
          cred["id"] = strToBin(cred["id"]);
        })

        get(credentialOptions);
      }
    });
  }
});
