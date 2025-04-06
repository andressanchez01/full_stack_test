import React from 'react';
import './PaymentSummary.css';

const PaymentSummary = ({ paymentData, onConfirm, onCancel }) => {
  if (!paymentData) {
    return (
      <div className="payment-summary-empty">
        No payment information available.
      </div>
    );
  }

  const formattedTotal = (paymentData.total_amount / 100).toFixed(2);

  return (
    <div className="payment-summary-container">
      <h2>Payment Summary</h2>
      <div className="payment-summary-details">
        <p>
          <strong>Transaction ID:</strong> {paymentData.id}
        </p>
        <p>
          <strong>Status:</strong> {paymentData.status}
        </p>
        <p>
          <strong>Total Amount:</strong> ${formattedTotal}
        </p>
        <p>
          <strong>Currency:</strong> {paymentData.currency}
        </p>
        {/* Puedes agregar más detalles según sea necesario */}
      </div>
      <div className="payment-summary-actions">
        <button className="summary-button" onClick={onConfirm}>
          Confirm
        </button>
        <button className="summary-button cancel" onClick={onCancel}>
          Cancel
        </button>
      </div>
    </div>
  );
};

export default PaymentSummary;
