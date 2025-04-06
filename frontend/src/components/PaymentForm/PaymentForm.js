import React, { useState } from 'react';
import './PaymentForm.css';

const PaymentForm = ({ onSubmit }) => {
  const [cardData, setCardData] = useState({
    cardNumber: '',
    cardHolder: '',
    expiryMonth: '',
    expiryYear: '',
    cvv: ''
  });
  const [cardType, setCardType] = useState(null);
  const [errors, setErrors] = useState({});

  const detectCardType = (number) => {
    
    const visaRegex = /^4/;
    
    const mastercardRegex = /^(5[1-5]|222[1-9]|22[3-9]|2[3-6]|27[0-1]|2720)/;
    
    if (visaRegex.test(number)) {
      return 'visa';
    } else if (mastercardRegex.test(number)) {
      return 'mastercard';
    }
    return null;
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    
    if (name === 'cardNumber') {
      
      const cleaned = value.replace(/\D/g, '');
      
      const formatted = cleaned.slice(0, 16);
      
      setCardData({
        ...cardData,
        [name]: formatted
      });
      
      setCardType(detectCardType(formatted));
    } else {
      setCardData({
        ...cardData,
        [name]: value
      });
    }
  };

  const validateForm = () => {
    const newErrors = {};
    
    
    if (!cardData.cardNumber) {
      newErrors.cardNumber = 'El número de tarjeta es requerido';
    } else if (cardData.cardNumber.length < 13 || cardData.cardNumber.length > 16) {
      newErrors.cardNumber = 'El número de tarjeta debe tener entre 13 y 16 dígitos';
    }
    
    
    if (!cardData.cardHolder) {
      newErrors.cardHolder = 'El nombre del titular es requerido';
    }
    
    
    if (!cardData.expiryMonth) {
      newErrors.expiryMonth = 'El mes es requerido';
    } else if (parseInt(cardData.expiryMonth) < 1 || parseInt(cardData.expiryMonth) > 12) {
      newErrors.expiryMonth = 'Mes inválido';
    }
    
    if (!cardData.expiryYear) {
      newErrors.expiryYear = 'El año es requerido';
    } else {
      const currentYear = new Date().getFullYear() % 100;
      if (parseInt(cardData.expiryYear) < currentYear) {
        newErrors.expiryYear = 'Año inválido';
      }
    }
    
    
    if (!cardData.cvv) {
      newErrors.cvv = 'El CVV es requerido';
    } else if (cardData.cvv.length < 3 || cardData.cvv.length > 4) {
      newErrors.cvv = 'El CVV debe tener 3 o 4 dígitos';
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    
    if (validateForm()) {
      onSubmit(cardData);
    }
  };

  return (
    <div className="payment-form-container">
      <h2>Información de Pago</h2>
      <form className="payment-form" onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="cardNumber">Número de Tarjeta</label>
          <div className="card-number-input">
            <input
              type="text"
              id="cardNumber"
              name="cardNumber"
              value={cardData.cardNumber}
              onChange={handleChange}
              placeholder="1234 5678 9012 3456"
              maxLength="16"
            />
            {cardType && (
              <div className={`card-logo ${cardType}`}>
                {cardType === 'visa' ? 'VISA' : 'MASTERCARD'}
              </div>
            )}
          </div>
          {errors.cardNumber && <div className="error">{errors.cardNumber}</div>}
        </div>
        
        <div className="form-group">
          <label htmlFor="cardHolder">Titular de la Tarjeta</label>
          <input
            type="text"
            id="cardHolder"
            name="cardHolder"
            value={cardData.cardHolder}
            onChange={handleChange}
            placeholder="Juan Pérez"
          />
          {errors.cardHolder && <div className="error">{errors.cardHolder}</div>}
        </div>
        
        <div className="form-row">
          <div className="form-group half">
            <label htmlFor="expiryMonth">Mes de Expiración</label>
            <input
              type="text"
              id="expiryMonth"
              name="expiryMonth"
              value={cardData.expiryMonth}
              onChange={handleChange}
              placeholder="MM"
              maxLength="2"
            />
            {errors.expiryMonth && <div className="error">{errors.expiryMonth}</div>}
          </div>
          
          <div className="form-group half">
            <label htmlFor="expiryYear">Año de Expiración</label>
            <input
              type="text"
              id="expiryYear"
              name="expiryYear"
              value={cardData.expiryYear}
              onChange={handleChange}
              placeholder="YY"
              maxLength="2"
            />
            {errors.expiryYear && <div className="error">{errors.expiryYear}</div>}
          </div>
        </div>
        
        <div className="form-group">
          <label htmlFor="cvv">CVV</label>
          <input
            type="text"
            id="cvv"
            name="cvv"
            value={cardData.cvv}
            onChange={handleChange}
            placeholder="123"
            maxLength="4"
          />
          {errors.cvv && <div className="error">{errors.cvv}</div>}
        </div>
        
        <button type="submit" className="submit-button">Continuar</button>
      </form>
    </div>
  );
};

export default PaymentForm;