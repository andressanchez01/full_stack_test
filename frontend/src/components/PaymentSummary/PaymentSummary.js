import React, { useState } from 'react';
import './PaymentSummary.css';

const PaymentSummary = ({
  product,
  quantity,
  paymentData,
  deliveryData,
  onConfirm,
  onCancel
}) => {
  const [isProcessing, setIsProcessing] = useState(false);

  const isDataComplete =
    product && quantity && paymentData && deliveryData;

  if (!isDataComplete) {
    return (
      <div className="payment-summary-empty">
        Información incompleta para mostrar el resumen.
      </div>
    );
  }

  const productTotal = Number(product.price) * quantity;
  const baseFee = Number(paymentData.base_fee);
  const deliveryFee = Number(paymentData.delivery_fee);
  const totalAmount = Number(paymentData.total_amount);
  const iva = Number(paymentData.iva);

  const handleConfirm = async () => {
    setIsProcessing(true);
    try {
      await onConfirm();
    } catch (error) {
      console.error('Error al procesar el pago:', error);
    } finally {
      setIsProcessing(false);
    }
  };

  return (
    <div className="payment-summary-container">
      <h2>Resumen de Pago</h2>

      {isProcessing ? (
        <div className="payment-processing-message">
          <div className="spinner" />
          <p>Procesando el pago, por favor espera...</p>
        </div>
      ) : (
        <>
          <div className="payment-summary-details">
            <h3>Producto</h3>
            <p><strong>Nombre:</strong> {product.name}</p>
            <p><strong>Precio unitario:</strong> ${Number(product.price).toLocaleString()}</p>
            <p><strong>Cantidad:</strong> {quantity}</p>
            <p><strong>Subtotal producto:</strong> ${productTotal.toLocaleString()}</p>
            <p><strong>iva:</strong> ${iva.toLocaleString()}</p>

            <h3>Tarifas</h3>
            <p><strong>Tarifa base:</strong> ${baseFee.toLocaleString()}</p>
            <p><strong>Costo de envío:</strong> ${deliveryFee.toLocaleString()}</p>

            <p className="payment-summary-total"><strong>Total:</strong> ${totalAmount.toLocaleString()}</p>

            <h3>Datos de envío</h3>
            <p><strong>Dirección:</strong> {deliveryData.address}</p>
            <p><strong>Ciudad:</strong> {deliveryData.city}</p>
          </div>

          <div className="payment-summary-actions">
            {onConfirm && (
              <button className="summary-button" onClick={handleConfirm}>
                Confirmar y pagar
              </button>
            )}
            {onCancel && (
              <button className="summary-button cancel" onClick={onCancel}>
                Cancelar
              </button>
            )}
          </div>
        </>
      )}
    </div>
  );
};

export default PaymentSummary;
