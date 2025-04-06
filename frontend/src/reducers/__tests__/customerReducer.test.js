import customerReducer from '../customerReducer';
import {
  SAVE_CUSTOMER_REQUEST,
  SAVE_CUSTOMER_SUCCESS,
  SAVE_CUSTOMER_FAILURE,
} from '../../actions/customerActions';

describe('customerReducer', () => {
  const initialState = {
    loading: false,
    data: null,
    error: null,
  };

  it('should return the initial state', () => {
    expect(customerReducer(undefined, {})).toEqual(initialState);
  });

  it('should handle SAVE_CUSTOMER_REQUEST', () => {
    const action = { type: SAVE_CUSTOMER_REQUEST };
    const expectedState = {
      ...initialState,
      loading: true,
      error: null,
    };
    expect(customerReducer(initialState, action)).toEqual(expectedState);
  });

  it('should handle SAVE_CUSTOMER_SUCCESS', () => {
    const payload = { id: 1, name: 'John Doe', email: 'john.doe@example.com' };
    const action = { type: SAVE_CUSTOMER_SUCCESS, payload };
    const expectedState = {
      ...initialState,
      loading: false,
      data: payload,
    };
    expect(customerReducer(initialState, action)).toEqual(expectedState);
  });

  it('should handle SAVE_CUSTOMER_FAILURE', () => {
    const payload = 'Error al guardar el cliente';
    const action = { type: SAVE_CUSTOMER_FAILURE, payload };
    const expectedState = {
      ...initialState,
      loading: false,
      error: payload,
    };
    expect(customerReducer(initialState, action)).toEqual(expectedState);
  });
});