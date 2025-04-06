import React, { useState } from 'react';
import './DeliveryForm.css';

const DeliveryForm = ({ onSubmit }) => {
  const [deliveryData, setDeliveryData] = useState({
    name: '',
    email: '',
    phone: '',
    address: '',
    city: '',
    postalCode: ''
  });
  const [errors, setErrors] = useState({});

  const handleChange = (e) => {
    const { name, value } = e.target;
    setDeliveryData({
      ...deliveryData,
      [name]: value
    });
  };

  const validateForm = () => {
    const newErrors = {};
    
    if (!deliveryData.name) newErrors.name = 'El nombre es requerido';
    
    if (!deliveryData.email) {
      newErrors.email = 'El email es requerido';
    } else if (!/\S+@\S+\.\S+/.test(deliveryData.email)) {
      newErrors.email = 'Email inválido';
    }
    
    if (!deliveryData.phone) {
      newErrors.phone = 'El teléfono es requerido';
    } else if (!/^\d{10}$/.test(deliveryData.phone)) {
      newErrors.phone = 'Teléfono inválido (10 dígitos)';
    }
    
    if (!deliveryData.address) newErrors.address = 'La dirección es requerida';
    if (!deliveryData.city) newErrors.city = 'La ciudad es requerida';
    if (!deliveryData.postalCode) newErrors.postalCode = 'El código postal es requerido';
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    
    if (validateForm()) {
      onSubmit(deliveryData);
    }
  };

  return (
    <div className="delivery-form-container">
      <h2>Información de Envío</h2>
      <form className="delivery-form" onSubmit={handleSubmit}>
        <div className="form-group">
          <label htmlFor="name">Nombre Completo</label>
          <input
            type="text"
            id="name"
            name="name"
            value={deliveryData.name}
            onChange={handleChange}
            placeholder="Juan Pérez"
          />
          {errors.name && <div className="error">{errors.name}</div>}
        </div>
        
        <div className="form-group">
          <label htmlFor="email">Email</label>
          <input
            type="email"
            id="email"
            name="email"
            value={deliveryData.email}
            onChange={handleChange}
            placeholder="juan@ejemplo.com"
          />
          {errors.email && <div className="error">{errors.email}</div>}
        </div>
        
        <div className="form-group">
          <label htmlFor="phone">Teléfono</label>
          <input
            type="tel"
            id="phone"
            name="phone"
            value={deliveryData.phone}
            onChange={handleChange}
            placeholder="1234567890"
          />
          {errors.phone && <div className="error">{errors.phone}</div>}
        </div>
        
        <div className="form-group">
          <label htmlFor="address">Dirección</label>
          <input
            type="text"
            id="address"
            name="address"
            value={deliveryData.address}
            onChange={handleChange}
            placeholder="Calle Principal #123"
          />
          {errors.address && <div className="error">{errors.address}</div>}
        </div>
        
        <div className="form-row">
          <div className="form-group half">
            <label htmlFor="city">Ciudad</label>
            <input
              type="text"
              id="city"
              name="city"
              value={deliveryData.city}
              onChange={handleChange}
              placeholder="Ciudad"
            />
            {errors.city && <div className="error">{errors.city}</div>}
          </div>
          
          <div className="form-group half">
            <label htmlFor="postalCode">Código Postal</label>
            <input
              type="text"
              id="postalCode"
              name="postalCode"
              value={deliveryData.postalCode}
              onChange={handleChange}
              placeholder="12345"
            />
            {errors.postalCode && <div className="error">{errors.postalCode}</div>}
          </div>
        </div>
        
        <button type="submit" className="submit-button">Enviar</button>
      </form>
    </div>
  );
};

export default DeliveryForm;