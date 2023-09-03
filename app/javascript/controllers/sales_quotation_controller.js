import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    console.log("SalesQuotationController is connected!");
}

  
  static targets = ["customerIdInput", "representativeSelect"];
  
  fetchRepresentatives() {
    console.log("fetchRepresentatives is triggered");
    const customerId = this.customerIdInputTarget.value;
    console.log("Customer ID:", customerId);

    if (!customerId) return;
  
    Turbo.visit(`/sales_quotations/representative_options?id=${customerId}`, { action: "replace", target: "representative_options" });
  }
}

