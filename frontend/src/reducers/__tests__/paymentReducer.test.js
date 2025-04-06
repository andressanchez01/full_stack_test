import paymentReducer from '../paymentReducer';
import {
  PROCESS_PAYMENT_REQUEST,
  PROCESS_PAYMENT_SUCCESS,
  PROCESS_PAYMENT_FAILURE,
} from '../../actions/paymentActions';

describe('paymentReducer', () => {
  const initialState = {
    loading: false,
    data: null,
    error: null,
  };

  it('should return the initial state', () => {
    expect(paymentReducer(undefined, {})).toEqual(initialState);
  });

  it('should handle PROCESS_PAYMENT_REQUEST', () => {
    const action = { type: PROCESS_PAYMENT_REQUEST };
    const expectedState = {
      ...initialState,
      loading: true,
      error: null,
    };
    expect(paymentReducer(initialState, action)).toEqual(expectedState);
  });

  it('should handle PROCESS_PAYMENT_SUCCESS', () => {
    const payload = { transactionId: '12345', status: 'APPROVED' };
    const action = { type: PROCESS_PAYMENT_SUCCESS, payload };
    const expectedState = {
      ...initialState,
      loading: false,
      data: payload,
    };
    expect(paymentReducer(initialState, action)).toEqual(expectedState);
  });

  it('should handle PROCESS_PAYMENT_FAILURE', () => {
    const payload = 'Error al procesar el pago';
    const action = { type: PROCESS_PAYMENT_FAILURE, payload };
    const expectedState = {
      ...initialState,
      loading: false,
      error: payload,
      data: null,
    };
    expect(paymentReducer(initialState, action)).toEqual(expectedState);
  });
});