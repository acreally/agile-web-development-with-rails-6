import React from 'react'

import NoPayType from './NoPayType'
import CreditCardPayType from './CreditCardPayType'
import CheckPayType from './CheckPayType'
import PurchaseOrderPayType from './PurchaseOrderPayType'
// continue on pg 223

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
    return (
      <div className="field">
        <label htmlFor="order_pay_type">Pay type</label>
        <select id="pay_type" onChange={this.onPayTypeSelected} name="order[payment_type_id]">
          <option value="">Select a payment method</option> 
          <option value="0">Check</option>
          <option value="1">Credit card</option>
          <option value="2">Purchase order</option>
        </select>
      </div>
    );
  }
}
export default PayTypeSelector

