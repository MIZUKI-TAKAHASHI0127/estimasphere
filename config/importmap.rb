# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.js"
pin "stimulus", to: "stimulus.js"

pin "controllers/sales_quotation_controller", to: "controllers/sales_quotation_controller.js"
pin "controllers/amount_controller", to: "controllers/amount_controller.js"
pin "controllers/hello_controller", to: "controllers/hello_controller.js"