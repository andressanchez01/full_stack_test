import {
    PROCESS_PAYMENT_REQUEST,
    PROCESS_PAYMENT_SUCCESS,
    PROCESS_PAYMENT_FAILURE
  } from '../actions/paymentActions';
  
  const initialState = {
    loading: false,
    data: null,    // Cambiado de 'result' a 'data'
    error: null
  };
  
  const paymentReducer = (state = initialState, action) => {
    switch (action.type) {
      case PROCESS_PAYMENT_REQUEST:
        return { ...state, loading: true, error: null };
      case PROCESS_PAYMENT_SUCCESS:
        return { ...state, loading: false, data: action.payload }; // 'data' aquí
      case PROCESS_PAYMENT_FAILURE:
        return { ...state, loading: false, error: action.payload, data: null };
      default:
        return state;
    }
  };
  
  export default paymentReducer;