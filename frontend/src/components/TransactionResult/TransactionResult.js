import React from 'react';
import './TransactionResult.css';

const TransactionResult = ({ success, message, onBackToHome }) => {
  return (
    <div className={`transaction-result-container ${success ? 'success' : 'error'}`}>
      <div className="transaction-icon">
        {success ? '✅' : '❌'}
      </div>
      <h2 className="transaction-title">
        {success ? '¡Pago exitoso!' : 'Ocurrió un error'}
      </h2>
      <p className="transaction-message">{message}</p>
      <button className="back-button" onClick={onBackToHome}>
        Volver al inicio
      </button>
    </div>
  );
};

export default TransactionResult;
