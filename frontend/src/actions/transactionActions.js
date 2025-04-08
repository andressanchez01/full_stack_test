import axios from 'axios';

export const CREATE_TRANSACTION_REQUEST = 'CREATE_TRANSACTION_REQUEST';
export const CREATE_TRANSACTION_SUCCESS = 'CREATE_TRANSACTION_SUCCESS';
export const CREATE_TRANSACTION_FAILURE = 'CREATE_TRANSACTION_FAILURE';

export const UPDATE_TRANSACTION_REQUEST = 'UPDATE_TRANSACTION_REQUEST';
export const UPDATE_TRANSACTION_SUCCESS = 'UPDATE_TRANSACTION_SUCCESS';
export const UPDATE_TRANSACTION_FAILURE = 'UPDATE_TRANSACTION_FAILURE';

export const RESET_TRANSACTION = 'RESET_TRANSACTION';

const API_URL = process.env.REACT_APP_API_URL || 'http://18.188.146.79:3000/api';

/**
 * Crea una nueva transacción en el backend
 * @param {Object} transactionData - Datos del producto, cantidad, delivery y customer
 * @returns {Function} dispatch => Promise<data>
 */
export const createTransaction = (transactionData) => {
  return async (dispatch) => {
    dispatch({ type: CREATE_TRANSACTION_REQUEST });

    try {
      const response = await axios.post(`${API_URL}/transactions`, transactionData);
      console.log('🧾 Respuesta completa de createTransaction:', response);
      const data = response.data.data;

      if (!data) throw new Error('⚠️ No se recibió la transacción del backend');

      dispatch({ type: CREATE_TRANSACTION_SUCCESS, payload: data });
      localStorage.setItem('currentTransaction', JSON.stringify(data));

      return data;
    } catch (error) {
      const message = error.response?.data?.message || error.message;
      dispatch({ type: CREATE_TRANSACTION_FAILURE, payload: message });
      localStorage.removeItem('currentTransaction');
      throw new Error(message);
    }
  };
};

/**
 * Procesa el pago de una transacción existente
 * @param {string} transactionId
 * @param {Object} cardData
 * @returns {Function} dispatch => Promise<data>
 */
export const processPayment = (transactionId, cardData) => {
  return async (dispatch) => {
    dispatch({ type: UPDATE_TRANSACTION_REQUEST });

    try {
      const response = await axios.put(`${API_URL}/transactions/${transactionId}`, {
        status: 'COMPLETED',
        card_data: cardData,
      });

      const data = response.data.data;

      if (!data) throw new Error('⚠️ No se recibió la transacción actualizada');

      dispatch({ type: UPDATE_TRANSACTION_SUCCESS, payload: data });
      localStorage.setItem('currentTransaction', JSON.stringify(data));

      return data;
    } catch (error) {
      const message = error.response?.data?.message || error.message;
      dispatch({ type: UPDATE_TRANSACTION_FAILURE, payload: message });
      localStorage.removeItem('currentTransaction');
      throw new Error(message);
    }
  };
};

/**
 * Limpia la transacción almacenada
 */
export const resetTransaction = () => {
  localStorage.removeItem('currentTransaction');
  return { type: RESET_TRANSACTION };
};

/**
 * Restaura una transacción desde localStorage
 */
export const recoverTransaction = () => {
  return (dispatch) => {
    const savedTransaction = localStorage.getItem('currentTransaction');

    if (savedTransaction) {
      dispatch({
        type: CREATE_TRANSACTION_SUCCESS,
        payload: JSON.parse(savedTransaction),
      });
    }
  };
};
