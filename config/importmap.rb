# NB: We aren't actually using this importmap. However, I'm leaving it here to ease
#     our return if we decide to use it again. See #191.

# Pin npm packages by running ./bin/importmap
pin "application", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/channels", under: "channels"
