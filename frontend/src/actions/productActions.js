import axios from 'axios';

export const FETCH_PRODUCTS_REQUEST = 'FETCH_PRODUCTS_REQUEST';
export const FETCH_PRODUCTS_SUCCESS = 'FETCH_PRODUCTS_SUCCESS';
export const FETCH_PRODUCTS_FAILURE = 'FETCH_PRODUCTS_FAILURE';
export const FETCH_PRODUCT_DETAIL_REQUEST = 'FETCH_PRODUCT_DETAIL_REQUEST';
export const FETCH_PRODUCT_DETAIL_SUCCESS = 'FETCH_PRODUCT_DETAIL_SUCCESS';
export const FETCH_PRODUCT_DETAIL_FAILURE = 'FETCH_PRODUCT_DETAIL_FAILURE';

const API_URL = process.env.REACT_APP_API_URL || 'http://18.188.146.79:3000/api';

export const fetchProducts = () => {
  return async (dispatch) => {
    dispatch({ type: FETCH_PRODUCTS_REQUEST });
    
    try {
      const response = await axios.get(`${API_URL}/products`);
      dispatch({
        type: FETCH_PRODUCTS_SUCCESS,
        payload: response.data.data
      });
    } catch (error) {
      dispatch({
        type: FETCH_PRODUCTS_FAILURE,
        payload: error.message
      });
    }
  };
};

export const fetchProductDetail = (productId) => {
  return async (dispatch) => {
    dispatch({ type: FETCH_PRODUCT_DETAIL_REQUEST });
    
    try {
      const response = await axios.get(`${API_URL}/products/${productId}`);
      dispatch({
        type: FETCH_PRODUCT_DETAIL_SUCCESS,
        payload: response.data.data
      });
    } catch (error) {
      dispatch({
        type: FETCH_PRODUCT_DETAIL_FAILURE,
        payload: error.message
      });
    }
  };
};