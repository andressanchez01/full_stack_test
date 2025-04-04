import { configureStore, applyMiddleware, combineReducers } from 'redux';
import thunk from 'redux-thunk';
import productReducer from './reducers/productReducer';
import customerReducer from './reducers/customerReducer';
import transactionReducer from './reducers/transactionReducer';

const rootReducer = combineReducers({
  products: productReducer,
  customer: customerReducer,
  transaction: transactionReducer
});

const store = configureStore(rootReducer, applyMiddleware(thunk));

export default store;