import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import TransactionResult from '../components/TransactionResult/TransactionResult';

const TransactionResultPage = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const { success, message, transactionId } = location.state || {};

  const handleBackToHome = () => {
    navigate('/');
  };

  return (
    <div className="container mx-auto px-4 py-8">
      <TransactionResult
        success={success}
        message={message}
        transactionId={transactionId}
        onBack={handleBackToHome}
      />
    </div>
  );
};

export default TransactionResultPage;
