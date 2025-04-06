import { configureStore } from '@reduxjs/toolkit';
import thunk from 'redux-thunk';
import paymentReducer from './reducers/paymentReducer'; // Asegúrate de que esta ruta sea correcta

export const createTestStore = () => {
    return configureStore({
      reducer: {
        payment: paymentReducer,
      },
      // middleware no es necesario si solo usás thunk
    });
  };