import axios from 'axios';

export const SAVE_CUSTOMER_REQUEST = 'SAVE_CUSTOMER_REQUEST';
export const SAVE_CUSTOMER_SUCCESS = 'SAVE_CUSTOMER_SUCCESS';
export const SAVE_CUSTOMER_FAILURE = 'SAVE_CUSTOMER_FAILURE';

export const saveCustomer = (customerData) => async (dispatch) => {
  dispatch({ type: SAVE_CUSTOMER_REQUEST });

  try {
    const response = await axios.post('http://localhost:4567/customers', customerData);
    dispatch({
      type: SAVE_CUSTOMER_SUCCESS,
      payload: response.data,
    });
  } catch (error) {
    dispatch({
      type: SAVE_CUSTOMER_FAILURE,
      payload: error.response?.data?.message || 'Error al guardar el cliente',
    });
  }
};
