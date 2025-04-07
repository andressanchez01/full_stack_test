import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useParams } from 'react-router-dom';
import { fetchProductDetail } from '../actions/productActions';
import ProductDetail from '../components/ProductDetail/ProductDetail';

const ProductDetailPage = () => {
  const { productId } = useParams();
  const dispatch = useDispatch();

  const { detail, loadingDetail, errorDetail } = useSelector(state => state.products);

  useEffect(() => {
    if (productId) {
      dispatch(fetchProductDetail(productId));
    }
  }, [dispatch, productId]);

  if (loadingDetail) return <div className="text-center py-8">Cargando producto...</div>;
  if (errorDetail) return <div className="text-center text-red-600 py-8">Error: {errorDetail}</div>;
  if (!detail) return <div className="text-center py-8">Producto no encontrado.</div>;

  return (
    <div className="container mx-auto px-4 py-8">
      <ProductDetail product={detail} />
    </div>
  );
};

export default ProductDetailPage;
