import React, { useState } from 'react';
import DeliveryForm from '../components/DeliveryForm/DeliveryForm';
import PaymentForm from '../components/PaymentForm/PaymentForm';
import PaymentSummary from '../components/PaymentSummary/PaymentSummary';
import { useNavigate, useLocation } from 'react-router-dom';
import { useDispatch } from 'react-redux';
import {
  createTransaction,
  processPayment,
} from '../actions/transactionActions';

const CheckoutPage = () => {
  const [deliveryData, setDeliveryData] = useState(null);
  const [paymentData, setPaymentData] = useState(null);
  const [transactionData, setTransactionData] = useState(null);
  const [step, setStep] = useState('delivery');

  const dispatch = useDispatch();
  const navigate = useNavigate();
  const location = useLocation();
  const { product, quantity } = location.state || {};

  const handleDeliverySubmit = (delivery) => {
    setDeliveryData(delivery);
    setStep('payment');
  };

  const handlePaymentSubmit = async (payment) => {
    setPaymentData(payment);
    console.log('📦 Payment form submitted:', payment);

    try {
      const transaction = await createTransaction({
        product_id: product.id,
        quantity,
        delivery: deliveryData,
        customer: {
          full_name: deliveryData.fullName,
          email: deliveryData.email,
        },
      })(dispatch); // 👈 Ejecutamos el thunk manualmente con dispatch

      console.log('✅ Transaction created:', transaction);

      if (!transaction) {
        throw new Error('⚠️ No se recibió la transacción del backend');
      }

      setTransactionData(transaction);
      setStep('summary');
    } catch (err) {
      console.error('❌ Error en handlePaymentSubmit:', err);
      navigate('/result', {
        state: {
          success: false,
          message: 'Error al crear la transacción. Intenta nuevamente.',
        },
      });
    }
  };

  const handleConfirmPayment = async () => {
    try {
      const updatedTransaction = await processPayment(
        transactionData.id,
        paymentData
      )(dispatch); // 👈 Ejecutamos el thunk manualmente con dispatch

      navigate('/result', {
        state: {
          success: true,
          transaction: updatedTransaction,
          product,
          quantity,
          delivery: deliveryData,
        },
      });
    } catch (err) {
      console.error('❌ Error en handleConfirmPayment:', err);
      navigate('/result', {
        state: {
          success: false,
          message: 'Error al procesar el pago. Intenta nuevamente.',
          product,
          quantity,
          delivery: deliveryData,
        },
      });
    }
  };

  return (
    <div className="container mx-auto px-4">
      <h1 className="text-2xl font-bold my-4">Finalizar Compra</h1>

      {step === 'delivery' && (
        <DeliveryForm onSubmit={handleDeliverySubmit} />
      )}

      {step === 'payment' && deliveryData && (
        <PaymentForm onSubmit={handlePaymentSubmit} />
      )}

      {step === 'summary' && transactionData && (
        <PaymentSummary
          product={product}
          quantity={quantity}
          paymentData={transactionData}
          deliveryData={deliveryData}
          onConfirm={handleConfirmPayment}
          onCancel={() => navigate('/')}
        />
      )}
    </div>
  );
};

export default CheckoutPage;
