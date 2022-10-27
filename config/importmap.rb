# Pin npm packages by running ./bin/importmap
pin "application", preload: true
pin "utilities", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "@rails/activestorage", to: "activestorage.esm.js"
pin_all_from "app/javascript/channels", under: "channels"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "dayjs" # @1.11.5
pin "dayjs/plugin/utc", to: "dayjs--plugin--utc.js" # @1.11.5
