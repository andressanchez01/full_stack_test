import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { fetchProducts } from '../actions/productActions';
import ProductList from '../components/ProductList/ProductList';

const HomePage = () => {
  const dispatch = useDispatch();
  const { items: products, loading, error } = useSelector(state => state.products);

  useEffect(() => {
    dispatch(fetchProducts());
  }, [dispatch]);

  return (
    <div className="bg-gray-50 min-h-screen">
      {/* Header visual */}
      <header className="bg-gradient-to-r from-blue-600 to-indigo-600 text-white py-12 shadow-md">
        <div className="text-center">
          <h1 className="text-4xl font-bold mb-2">¡Bienvenido a la tienda Dev!</h1>
          <p className="text-lg">Encuentra los mejores productos para desarrolladores</p>
        </div>
      </header>

      {/* Sección de productos */}
      <main className="container mx-auto px-4 py-8">
        <h2 className="text-2xl font-semibold mb-6 text-gray-800">Productos disponibles</h2>

        {loading && <p className="text-blue-600">Cargando productos...</p>}
        {error && <p className="text-red-600">Error al cargar productos: {error}</p>}
        <ProductList products={products} />
      </main>
    </div>
  );
};

export default HomePage;
