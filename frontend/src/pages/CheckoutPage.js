import React, { useState } from 'react';
import DeliveryForm from '../components/DeliveryForm/DeliveryForm';
import PaymentForm from '../components/PaymentForm/PaymentForm';
import PaymentSummary from '../components/PaymentSummary/PaymentSummary';
import { useNavigate } from 'react-router-dom';

const CheckoutPage = () => {
  const [deliveryData, setDeliveryData] = useState(null);
  const [paymentData, setPaymentData] = useState(null);
  const navigate = useNavigate();

  const handleDeliverySubmit = (data) => {
    setDeliveryData(data);
  };

  const handlePaymentSubmit = (data) => {
    setPaymentData(data);

    navigate('/transaction-result', {
      state: {
        delivery: deliveryData,
        payment: data
      }
    });
  };

  return (
    <div className="container mx-auto px-4">
      <h1 className="text-2xl font-bold my-4">Finalizar Compra</h1>
      
      {!deliveryData ? (
        <DeliveryForm onSubmit={handleDeliverySubmit} />
      ) : !paymentData ? (
        <PaymentForm onSubmit={handlePaymentSubmit} />
      ) : (
        <PaymentSummary deliveryData={deliveryData} paymentData={paymentData} />
      )}
    </div>
  );
};

export default CheckoutPage;
