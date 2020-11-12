import React from 'react'

import NoPayType from './NoPayType'
import CreditCardPayType from './CreditCardPayType'
import CheckPayType from './CheckPayType'
import PurchaseOrderPayType from './PurchaseOrderPayType'

class PayTypeSelector extends React.Component {
  constructor(props) {
    super(props);
    this.onPayTypeSelected= this.onPayTypeSelected.bind(this)
    this.state = { selectedPayType: null };
  }

  onPayTypeSelected(event) {
    this.setState({ selectedPayType: event.target.value });
  }

  render() {
    let PayTypeCustomComponent = NoPayType;

    if (this.state.selectedPayType == "1") {
      PayTypeCustomComponent = CheckPayType;
    } else if (this.state.selectedPayType == "2") {
      PayTypeCustomComponent = CreditCardPayType;
    } else if (this.state.selectedPayType == "3") {
      PayTypeCustomComponent = PurchaseOrderPayType;
    }

    return (
      <div>
        <div className="field">
          <label htmlFor="order_pay_type">Pay type</label>
          <select id="order_pay_type" onChange={this.onPayTypeSelected} name="order[payment_type_id]">
            <option value="">Select a payment method</option>
            <option value="1">Check</option>
            <option value="2">Credit card</option>
            <option value="3">Purchase order</option>
          </select>
        </div>
        <PayTypeCustomComponent />
      </div>
    );
  }
}
export default PayTypeSelector

