import transactionReducer from '../transactionReducer';
import {
  CREATE_TRANSACTION_REQUEST,
  CREATE_TRANSACTION_SUCCESS,
  CREATE_TRANSACTION_FAILURE,
  UPDATE_TRANSACTION_REQUEST,
  UPDATE_TRANSACTION_SUCCESS,
  UPDATE_TRANSACTION_FAILURE,
  RESET_TRANSACTION
} from '../../actions/transactionActions';

describe('transactionReducer', () => {
  const initialState = {
    currentTransaction: null,
    loading: false,
    error: null,
    success: false
  };

  it('should return the initial state', () => {
    expect(transactionReducer(undefined, {})).toEqual(initialState);
  });

  it('should handle CREATE_TRANSACTION_REQUEST', () => {
    const action = { type: CREATE_TRANSACTION_REQUEST };
    const expectedState = {
      ...initialState,
      loading: true
    };
    expect(transactionReducer(initialState, action)).toEqual(expectedState);
  });

  it('should handle CREATE_TRANSACTION_SUCCESS', () => {
    const mockTransaction = { id: 1, total: 1000 };
    const action = { type: CREATE_TRANSACTION_SUCCESS, payload: mockTransaction };
    const expectedState = {
      ...initialState,
      currentTransaction: mockTransaction,
      loading: false,
      success: true
    };
    expect(transactionReducer(initialState, action)).toEqual(expectedState);
  });

  it('should handle CREATE_TRANSACTION_FAILURE', () => {
    const action = { type: CREATE_TRANSACTION_FAILURE, payload: 'Error al crear' };
    const expectedState = {
      ...initialState,
      loading: false,
      error: 'Error al crear',
      success: false
    };
    expect(transactionReducer(initialState, action)).toEqual(expectedState);
  });

  it('should handle UPDATE_TRANSACTION_SUCCESS', () => {
    const updatedTransaction = { id: 1, status: 'COMPLETED' };
    const action = { type: UPDATE_TRANSACTION_SUCCESS, payload: updatedTransaction };
    const expectedState = {
      ...initialState,
      currentTransaction: updatedTransaction,
      loading: false,
      success: true
    };
    expect(transactionReducer(initialState, action)).toEqual(expectedState);
  });

  it('should handle RESET_TRANSACTION', () => {
    const modifiedState = {
      currentTransaction: { id: 1 },
      loading: true,
      error: 'Error',
      success: true
    };
    const action = { type: RESET_TRANSACTION };
    expect(transactionReducer(modifiedState, action)).toEqual(initialState);
  });
});
