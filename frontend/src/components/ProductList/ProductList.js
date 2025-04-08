import React from 'react';
import { Link } from 'react-router-dom';
import './ProductList.css';

const ProductList = ({ products }) => {
  if (!products || products.length === 0) {
    return <div className="empty-list">No hay productos disponibles.</div>;
  }

  return (
    <div className="product-grid">
      {products.map(product => (
        <div key={product.id} className="product-card">
          <div className="product-image">
            {/* Placeholder para imagen del producto */}
            <div className="placeholder-img"></div>
          </div>
          <div className="product-info">
            <h2>{product.name}</h2>
            <p className="product-description">{product.description}</p>
            <div className="product-meta">
            <span className="product-price">
              {product.price ? `$${parseFloat(product.price).toFixed(2)}` : 'Precio no disponible'}
            </span>
              <span className="product-stock">Stock: {product.stock_quantity}</span>
            </div>
            <Link to={`/product/${product.id}`} className="view-product-btn">
              Ver producto
            </Link>
          </div>
        </div>
      ))}
    </div>
  );
};

export default ProductList;