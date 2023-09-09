pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.js"
pin "stimulus", to: "stimulus.js"

pin_all_from "app/javascript/controllers", under: "controllers"