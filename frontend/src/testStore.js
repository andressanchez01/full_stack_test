import { configureStore } from '@reduxjs/toolkit';
import thunk from 'redux-thunk';
import paymentReducer from './reducers/paymentReducer'; 
import customerReducer from './reducers/customerReducer';
import productReducer from './reducers/productReducer';

export const createTestStore = () => {
    return configureStore({
      reducer: {
        payment: paymentReducer,
        customer: customerReducer,
        products: productReducer,
      },
    });
  };