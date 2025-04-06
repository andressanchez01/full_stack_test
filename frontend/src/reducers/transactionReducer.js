import {
    CREATE_TRANSACTION_REQUEST,
    CREATE_TRANSACTION_SUCCESS,
    CREATE_TRANSACTION_FAILURE,
    UPDATE_TRANSACTION_REQUEST,
    UPDATE_TRANSACTION_SUCCESS,
    UPDATE_TRANSACTION_FAILURE,
    RESET_TRANSACTION
  } from '../actions/transactionActions';
  
  const initialState = {
    currentTransaction: null,
    loading: false,
    error: null,
    success: false
  };
  
  const transactionReducer = (state = initialState, action) => {
    switch (action.type) {
      case CREATE_TRANSACTION_REQUEST:
      case UPDATE_TRANSACTION_REQUEST:
        return {
          ...state,
          loading: true,
          error: null,
          success: false
        };
      case CREATE_TRANSACTION_SUCCESS:
        return {
          ...state,
          loading: false,
          currentTransaction: action.payload,
          success: true
        };
      case UPDATE_TRANSACTION_SUCCESS:
        return {
          ...state,
          loading: false,
          currentTransaction: action.payload,
          success: true
        };
      case CREATE_TRANSACTION_FAILURE:
      case UPDATE_TRANSACTION_FAILURE:
        return {
          ...state,
          loading: false,
          error: action.payload,
          success: false
        };
      case RESET_TRANSACTION:
        return {
          ...initialState
        };
      default:
        return state;
    }
  };
  
export default transactionReducer;