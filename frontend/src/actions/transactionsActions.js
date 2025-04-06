import axios from 'axios';

export const CREATE_TRANSACTION_REQUEST = 'CREATE_TRANSACTION_REQUEST';
export const CREATE_TRANSACTION_SUCCESS = 'CREATE_TRANSACTION_SUCCESS';
export const CREATE_TRANSACTION_FAILURE = 'CREATE_TRANSACTION_FAILURE';
export const UPDATE_TRANSACTION_REQUEST = 'UPDATE_TRANSACTION_REQUEST';
export const UPDATE_TRANSACTION_SUCCESS = 'UPDATE_TRANSACTION_SUCCESS';
export const UPDATE_TRANSACTION_FAILURE = 'UPDATE_TRANSACTION_FAILURE';
export const RESET_TRANSACTION = 'RESET_TRANSACTION';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:4567/api';

export const createTransaction = (transactionData) => {
  return async (dispatch) => {
    dispatch({ type: CREATE_TRANSACTION_REQUEST });
    
    try {
      const response = await axios.post(`${API_URL}/transactions`, transactionData);
      
      dispatch({
        type: CREATE_TRANSACTION_SUCCESS,
        payload: response.data.data
      });
      
      localStorage.setItem('currentTransaction', JSON.stringify(response.data.data));
      
      return response.data.data;
    } catch (error) {
      dispatch({
        type: CREATE_TRANSACTION_FAILURE,
        payload: error.message
      });
      throw error;
    }
  };
};

export const processPayment = (transactionId, cardData) => {
  return async (dispatch) => {
    dispatch({ type: UPDATE_TRANSACTION_REQUEST });
    
    try {
      const response = await axios.put(`${API_URL}/transactions/${transactionId}`, {
        status: 'COMPLETED',
        card_data: cardData
      });
      
      dispatch({
        type: UPDATE_TRANSACTION_SUCCESS,
        payload: response.data.data
      });
      
      localStorage.setItem('currentTransaction', JSON.stringify(response.data.data));
      
      return response.data.data;
    } catch (error) {
      dispatch({
        type: UPDATE_TRANSACTION_FAILURE,
        payload: error.message
      });
      throw error;
    }
  };
};

export const resetTransaction = () => {
  localStorage.removeItem('currentTransaction');
  return { type: RESET_TRANSACTION };
};

export const recoverTransaction = () => {
  return (dispatch) => {
    const savedTransaction = localStorage.getItem('currentTransaction');
    
    if (savedTransaction) {
      dispatch({
        type: CREATE_TRANSACTION_SUCCESS,
        payload: JSON.parse(savedTransaction)
      });
    }
  };
};