import React, { useEffect, useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import axios from 'axios';
import './TransactionResult.css';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:4567/api';

const TransactionResult = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const {
    product,
    quantity,
    delivery,
    transaction: initialTransaction,
    success,
    message
  } = location.state || {};

  const [transactionStatus, setTransactionStatus] = useState(initialTransaction?.status);

  useEffect(() => {
    const fetchTransactionStatus = async () => {
      if (initialTransaction?.id) {
        try {
          const response = await axios.get(`${API_URL}/transactions/${initialTransaction.id}`);
          setTransactionStatus(response.data.data.status);
        } catch (err) {
          console.error('Error al obtener el estado actualizado de la transacción:', err);
        }
      }
    };

    fetchTransactionStatus();
  }, [initialTransaction?.id]);

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

  if (!product || !delivery || !initialTransaction) {
    return (
      <div className="text-center text-red-500 py-8">
        No se encontraron datos de la transacción.
      </div>
    );
  }

  return (
    <div className="transaction-result-container success">
      <div className="transaction-icon">✅</div>
      <h2 className="transaction-title">¡Pago exitoso!</h2>
      <p><strong>Producto:</strong> {product.name}</p>
      <p><strong>Cantidad:</strong> {quantity}</p>
      <p><strong>Total pagado:</strong> ${initialTransaction.total_amount}</p>
      <p><strong>Envío a:</strong> {`${delivery.address}, ${delivery.city}`}</p>
      <p><strong>Estado de pago:</strong> {transactionStatus || 'N/A'}</p>
      <p><strong>ID de transacción:</strong> {initialTransaction.id || 'N/A'}</p>
      <button className="back-button" onClick={handleBackToHome}>
        Volver al inicio
      </button>
    </div>
  );
};

export default TransactionResult;
