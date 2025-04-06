import {
    FETCH_PRODUCTS_REQUEST,
    FETCH_PRODUCTS_SUCCESS,
    FETCH_PRODUCTS_FAILURE,
    FETCH_PRODUCT_DETAIL_REQUEST,
    FETCH_PRODUCT_DETAIL_SUCCESS,
    FETCH_PRODUCT_DETAIL_FAILURE
  } from '../actions/productActions';
  
  const initialState = {
    products: [],
    currentProduct: null,
    loading: false,
    error: null
  };
  
  const productReducer = (state = initialState, action) => {
    switch (action.type) {
      case FETCH_PRODUCTS_REQUEST:
        return {
          ...state,
          loading: true,
          error: null
        };
      case FETCH_PRODUCTS_SUCCESS:
        return {
          ...state,
          loading: false,
          products: action.payload
        };
      case FETCH_PRODUCTS_FAILURE:
        return {
          ...state,
          loading: false,
          error: action.payload
        };
      case FETCH_PRODUCT_DETAIL_REQUEST:
        return {
          ...state,
          loading: true,
          error: null
        };
      case FETCH_PRODUCT_DETAIL_SUCCESS:
        return {
          ...state,
          loading: false,
          currentProduct: action.payload
        };
      case FETCH_PRODUCT_DETAIL_FAILURE:
        return {
          ...state,
          loading: false,
          error: action.payload
        };
      default:
        return state;
    }
  };
  
export default productReducer;