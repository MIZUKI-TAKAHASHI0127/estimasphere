
// Start Stimulus application
import "@hotwired/turbo-rails";
import { Application } from "stimulus";
const application = Application.start();

import AmountController from "./controllers/amount_controller";
application.register("amount", AmountController);
import HelloController from "./controllers/hello_controller";
application.register("hello", HelloController);

import SalesQuotationController from "./controllers/sales_quotation_controller";
application.register("sales_quotation", SalesQuotationController);
