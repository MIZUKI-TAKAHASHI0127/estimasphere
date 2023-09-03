import { Controller } from "stimulus";

// Connects to data-controller="amount"
export default class extends Controller {
  connect() {
    console.log("Amount controller connected!");
    this.calculate()
  }

  calculate() {
    var quantity = parseFloat(this.element.querySelector('.quantity').value) || 0;
    var unitPrice = parseFloat(this.element.querySelector('.unit_price').value) || 0;
    this.element.querySelector('.amount').innerText = (quantity * unitPrice).toLocaleString();
  }
}

