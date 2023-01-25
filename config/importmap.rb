# Pin npm packages by running ./bin/importmap
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "@rails/activestorage", to: "activestorage.esm.js"
pin "dayjs" # @1.11.5
pin "dayjs/plugin/utc", to: "dayjs--plugin--utc.js" # @1.11.5
pin "@github/webauthn-json", to: "https://ga.jspm.io/npm:@github/webauthn-json@2.0.2/dist/esm/webauthn-json.js"
pin "@github/webauthn-json/browser-ponyfill", to: "https://ga.jspm.io/npm:@github/webauthn-json@2.0.2/dist/esm/webauthn-json.browser-ponyfill.js"
pin "@rails/request.js", to: "https://ga.jspm.io/npm:@rails/request.js@0.0.8/src/index.js"

# Our JavaScript
pin "application", preload: true
pin "utilities", preload: true
pin_all_from "app/javascript/channels", under: "channels"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "lottie-web", to: "https://ga.jspm.io/npm:lottie-web@5.10.2/build/player/lottie.js"
