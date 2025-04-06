import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useParams } from 'react-router-dom';
import { fetchProductById } from '../actions/productActions';
import ProductDetail from '../components/ProductDetail/ProductDetail';

const ProductDetailPage = () => {
  const { productId } = useParams();
  const dispatch = useDispatch();

  const { selectedProduct, loading, error } = useSelector(state => state.products);

  useEffect(() => {
    if (productId) {
      dispatch(fetchProductById(productId));
    }
  }, [dispatch, productId]);

  if (loading) return <div className="text-center py-8">Cargando producto...</div>;
  if (error) return <div className="text-center text-red-600 py-8">Error: {error}</div>;
  if (!selectedProduct) return <div className="text-center py-8">Producto no encontrado.</div>;

  return (
    <div className="container mx-auto px-4 py-8">
      <ProductDetail product={selectedProduct} />
    </div>
  );
};

export default ProductDetailPage;
