import { configureStore } from '@reduxjs/toolkit';
import productReducer from './reducers/productReducer';
import customerReducer from './reducers/customerReducer';
import transactionReducer from './reducers/transactionReducer';

const store = configureStore({
  reducer: {
    products: productReducer,
    customer: customerReducer,
    transaction: transactionReducer,
  },

});

export default store;