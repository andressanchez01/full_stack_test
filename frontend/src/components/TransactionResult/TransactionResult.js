import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import './TransactionResult.css';

const TransactionResult = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const { product, quantity, delivery, transaction, success, message } = location.state || {};

  const handleBackToHome = () => {
    navigate('/');
  };

  if (!success) {
    return (
      <div className="transaction-result-container error">
        <div className="transaction-icon">❌</div>
        <h2 className="transaction-title">Ocurrió un error</h2>
        <p className="transaction-message">{message || 'No se pudo completar la transacción.'}</p>
        <button className="back-button" onClick={handleBackToHome}>
          Volver al inicio
        </button>
      </div>
    );
  }

  if (!product || !delivery || !transaction) {
    return (
      <div className="text-center text-red-500 py-8">
        No se encontraron datos de la transacción.
      </div>
    );
  }

  const total = (product.price * quantity).toFixed(2);

  return (
    <div className="transaction-result-container success">
      <div className="transaction-icon">✅</div>
      <h2 className="transaction-title">¡Pago exitoso!</h2>
      <p><strong>Producto:</strong> {product.name}</p>
      <p><strong>Cantidad:</strong> {quantity}</p>
      <p><strong>Total pagado:</strong> ${total}</p>
      <p><strong>Envío a:</strong> {`${delivery.address}, ${delivery.city}`}</p>
      <p><strong>Estado de pago:</strong> {transaction.status || 'N/A'}</p>
      <p><strong>ID de transacción:</strong> {transaction.id || 'N/A'}</p>
      <button className="back-button" onClick={handleBackToHome}>
        Volver al inicio
      </button>
    </div>
  );
};

export default TransactionResult;
