# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.1.2/app/assets/javascripts/rails-ujs.esm.js"
pin "credential"
pin "messenger"
pin "stub_credentials" if Rails.env.test?
pin "@material/list", to: "https://ga.jspm.io/npm:@material/list@4.0.0/dist/mdc.list.js"
pin "@material/menu", to: "https://ga.jspm.io/npm:@material/menu@4.0.0/dist/mdc.menu.js"
pin "@material/snackbar", to: "https://ga.jspm.io/npm:@material/snackbar@4.0.0/dist/mdc.snackbar.js"
pin "@material/textfield", to: "https://ga.jspm.io/npm:@material/textfield@4.0.0/dist/mdc.textfield.js"
pin "@material/top-app-bar", to: "https://ga.jspm.io/npm:@material/top-app-bar@4.0.0/dist/mdc.topAppBar.js"
pin "@github/webauthn-json", to: "https://ga.jspm.io/npm:@github/webauthn-json@2.1.1/dist/esm/webauthn-json.js"

# sinon
pin "sinon", to: "https://ga.jspm.io/npm:sinon@9.0.2/lib/sinon.js"
pin "@sinonjs/commons", to: "https://ga.jspm.io/npm:@sinonjs/commons@1.8.6/lib/index.js"
pin "@sinonjs/fake-timers", to: "https://ga.jspm.io/npm:@sinonjs/fake-timers@6.0.1/src/fake-timers-src.js"
pin "@sinonjs/formatio", to: "https://ga.jspm.io/npm:@sinonjs/formatio@5.0.1/lib/formatio.js"
pin "@sinonjs/samsam", to: "https://ga.jspm.io/npm:@sinonjs/samsam@5.3.1/lib/samsam.js"
pin "@sinonjs/text-encoding", to: "https://ga.jspm.io/npm:@sinonjs/text-encoding@0.7.2/index.js"
pin "diff", to: "https://ga.jspm.io/npm:diff@4.0.2/dist/diff.js"
pin "isarray", to: "https://ga.jspm.io/npm:isarray@0.0.1/index.js"
pin "just-extend", to: "https://ga.jspm.io/npm:just-extend@4.2.1/index.js"
pin "lodash.get", to: "https://ga.jspm.io/npm:lodash.get@4.4.2/index.js"
pin "nise", to: "https://ga.jspm.io/npm:nise@4.1.0/lib/index.js"
pin "path-to-regexp", to: "https://ga.jspm.io/npm:path-to-regexp@1.8.0/index.js"
pin "process", to: "https://ga.jspm.io/npm:@jspm/core@2.0.1/nodelibs/browser/process-production.js"
pin "supports-color", to: "https://ga.jspm.io/npm:supports-color@7.2.0/browser.js"
pin "type-detect", to: "https://ga.jspm.io/npm:type-detect@4.0.8/type-detect.js"
pin "util", to: "https://ga.jspm.io/npm:@jspm/core@2.0.1/nodelibs/browser/util.js"

# turbolinks
pin "turbolinks", to: "https://ga.jspm.io/npm:turbolinks@5.2.0/dist/turbolinks.js"
