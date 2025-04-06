import {
    SAVE_CUSTOMER_REQUEST,
    SAVE_CUSTOMER_SUCCESS,
    SAVE_CUSTOMER_FAILURE
  } from '../actions/customerActions';
  
  const initialState = {
    loading: false,
    data: null,
    error: null
  };
  
  const customerReducer = (state = initialState, action) => {
    switch (action.type) {
      case SAVE_CUSTOMER_REQUEST:
        return { ...state, loading: true, error: null };
  
      case SAVE_CUSTOMER_SUCCESS:
        return { ...state, loading: false, data: action.payload };
  
      case SAVE_CUSTOMER_FAILURE:
        return { ...state, loading: false, error: action.payload };
  
      default:
        return state;
    }
  };
  
export default customerReducer;
  