import axios from 'axios';

export const PROCESS_PAYMENT_REQUEST = 'PROCESS_PAYMENT_REQUEST';
export const PROCESS_PAYMENT_SUCCESS = 'PROCESS_PAYMENT_SUCCESS';
export const PROCESS_PAYMENT_FAILURE = 'PROCESS_PAYMENT_FAILURE';

export const processPayment = (paymentData) => async (dispatch) => {
  dispatch({ type: PROCESS_PAYMENT_REQUEST });

  try {
    const response = await axios.post('http://localhost:4567/payments', paymentData);
    dispatch({
      type: PROCESS_PAYMENT_SUCCESS,
      payload: response.data,
    });
  } catch (error) {
    dispatch({
      type: PROCESS_PAYMENT_FAILURE,
      payload: error.response?.data?.message || 'Error al procesar el pago',
    });
  }
};
