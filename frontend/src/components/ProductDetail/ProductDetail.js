import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import './ProductDetail.css';

const ProductDetail = ({ product }) => {
  const [quantity, setQuantity] = useState(1);
  const navigate = useNavigate();

  if (!product) {
    return (
      <div className="product-detail-empty">
        Producto no encontrado.
      </div>
    );
  }

  const handleBuyNow = () => {
    navigate('/checkout', {
      state: {
        product,
        quantity
      }
    });
  };

  return (
    <div className="product-detail-container">
      <div className="product-detail-image">
        {product.image_url ? (
          <img
            src={product.image_url}
            alt={product.name}
            className="product-detail-img"
          />
        ) : (
          <div className="placeholder-img-large">Sin imagen</div>
        )}
      </div>
      <div className="product-detail-info">
        <h2>{product.name}</h2>
        <p className="product-detail-description">{product.description}</p>
        <p className="product-detail-price">
          Precio: ${Number(product.price).toFixed(2)}
        </p>
        <p className="product-detail-stock">
          Stock disponible: {product.stock_quantity}
        </p>

        <div className="product-detail-quantity">
          <label htmlFor="quantity">Cantidad:</label>
          <input
            id="quantity"
            type="number"
            min="1"
            max={product.stock_quantity}
            value={quantity}
            onChange={(e) => setQuantity(Number(e.target.value))}
          />
        </div>

        <button
          className="add-to-cart-button"
          onClick={handleBuyNow}
          disabled={product.stock_quantity <= 0}
        >
          {product.stock_quantity > 0 ? 'Pagar con tarjeta de crédito' : 'Sin stock'}
        </button>
      </div>
    </div>
  );
};

export default ProductDetail;
