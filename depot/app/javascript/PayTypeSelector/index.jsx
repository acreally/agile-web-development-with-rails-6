import React from 'react'

class PayTypeSelector extends React.Component {
  render() {
    return (
      <div className="field">
        <label htmlFor="order_pay_type">Pay type</label>
        <select id="order_pay_type" name="order[payment_type_id]">
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

