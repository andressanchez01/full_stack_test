import React from 'react';
import './ProductDetail.css';

const ProductDetail = ({ product, onAddToCart }) => {
  if (!product) {
    return (
      <div className="product-detail-empty">
        Producto no encontrado.
      </div>
    );
  }

  return (
    <div className="product-detail-container">
      <div className="product-detail-image">
        {/* Placeholder para la imagen */}
        <div className="placeholder-img-large"></div>
      </div>
      <div className="product-detail-info">
        <h2>{product.name}</h2>
        <p className="product-detail-description">{product.description}</p>
        <p className="product-detail-price">
          Precio: ${product.price.toFixed(2)}
        </p>
        <p className="product-detail-stock">
          Stock disponible: {product.stock_quantity}
        </p>
        <button
          className="add-to-cart-button"
          onClick={() => onAddToCart(product)}
          disabled={product.stock_quantity <= 0}
        >
          {product.stock_quantity > 0 ? 'Agregar al carrito' : 'Sin stock'}
        </button>
      </div>
    </div>
  );
};

export default ProductDetail;
