import React from 'react';
import { BrowserRouter as DefaultRouter, Routes, Route } from 'react-router-dom';
import { Provider } from 'react-redux';
import store from './store';

import HomePage from './pages/HomePage';
import CheckoutPage from './pages/CheckoutPage';
import ResultPage from './pages/ResultPage';
import ProductDetailPage from './pages/ProductDetailPage';

import Footer from './components/Footer/Footer';

function App({ Router = DefaultRouter }) {
  return (
    <Provider store={store}>
      <Router>
        <div className="flex flex-col min-h-screen">
          <div className="App">
            <Routes>
              <Route path="/" element={<HomePage />} />
              <Route path="/checkout" element={<CheckoutPage />} />
              <Route path="/result" element={<ResultPage />} />
              <Route path="/product/:productId" element={<ProductDetailPage />} />
            </Routes>
          </div>
          <Footer />
        </div>
      </Router>
    </Provider>
  );
}

export default App;