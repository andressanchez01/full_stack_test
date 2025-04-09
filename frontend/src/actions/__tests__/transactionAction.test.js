import axios from 'axios';
import MockAdapter from 'axios-mock-adapter';
import { createTestStore } from '../../testStore';
import {
  CREATE_TRANSACTION_REQUEST,
  CREATE_TRANSACTION_SUCCESS,
  CREATE_TRANSACTION_FAILURE,
  UPDATE_TRANSACTION_REQUEST,
  UPDATE_TRANSACTION_SUCCESS,
  UPDATE_TRANSACTION_FAILURE,
  RESET_TRANSACTION,
  createTransaction,
  processPayment,
  resetTransaction,
  recoverTransaction,
} from '../transactionActions';

const mockAxios = new MockAdapter(axios);

describe('transactionActions', () => {
  let store;

  beforeEach(() => {
    store = createTestStore();
    mockAxios.reset();
    localStorage.clear();
  });

  describe('createTransaction', () => {
    it('dispatches CREATE_TRANSACTION_SUCCESS and updates state on success', async () => {
      const transactionData = { amount: 100, description: 'Test transaction' };
      const responseData = { id: 1, amount: 100, description: 'Test transaction' };

      mockAxios
        .onPost('http://18.188.146.79:3000/api/transactions', transactionData)
        .reply(200, { data: responseData });

      const result = await store.dispatch(createTransaction(transactionData));

      const state = store.getState().transaction;
      expect(state.loading).toBe(false);
      expect(state.currentTransaction).toEqual(responseData);
      expect(state.error).toBeNull();
      expect(state.success).toBe(true);
      expect(localStorage.getItem('currentTransaction')).toEqual(JSON.stringify(responseData));
      expect(result).toEqual(responseData);
    });

    it('dispatches CREATE_TRANSACTION_FAILURE and updates state on failure', async () => {
      const transactionData = { amount: 100, description: 'Test transaction' };
      const errorMessage = 'Error al crear la transacción';

      mockAxios
        .onPost('http://18.188.146.79:3000/api/transactions', transactionData)
        .reply(500, { message: errorMessage });

      await expect(store.dispatch(createTransaction(transactionData))).rejects.toThrow(errorMessage);

      const state = store.getState().transaction;
      expect(state.loading).toBe(false);
      expect(state.currentTransaction).toBeNull();
      expect(state.error).toBe(errorMessage);
      expect(state.success).toBe(false);
      expect(localStorage.getItem('currentTransaction')).toBeNull();
    });
  });

  describe('processPayment', () => {
    it('dispatches UPDATE_TRANSACTION_SUCCESS and updates state on success', async () => {
      const transactionId = 1;
      const cardData = { cardNumber: '4111111111111111', expiry: '12/25' };
      const responseData = { id: 1, status: 'COMPLETED' };

      mockAxios
        .onPut(`http://18.188.146.79:3000/api/transactions/${transactionId}`)
        .reply(200, { data: responseData });

      const result = await store.dispatch(processPayment(transactionId, cardData));

      const state = store.getState().transaction;
      expect(state.loading).toBe(false);
      expect(state.currentTransaction).toEqual(responseData);
      expect(state.error).toBeNull();
      expect(state.success).toBe(true);
      expect(localStorage.getItem('currentTransaction')).toEqual(JSON.stringify(responseData));
      expect(result).toEqual(responseData);
    });

    it('dispatches UPDATE_TRANSACTION_FAILURE and updates state on failure', async () => {
      const transactionId = 1;
      const cardData = { cardNumber: '4111111111111111', expiry: '12/25' };
      const errorMessage = 'Error al procesar el pago';

      mockAxios
        .onPut(`http://18.188.146.79:3000/api/transactions/${transactionId}`)
        .reply(500, { message: errorMessage });

      await expect(store.dispatch(processPayment(transactionId, cardData))).rejects.toThrow(errorMessage);

      const state = store.getState().transaction;
      expect(state.loading).toBe(false);
      expect(state.currentTransaction).toBeNull();
      expect(state.error).toBe(errorMessage);
      expect(state.success).toBe(false);
      expect(localStorage.getItem('currentTransaction')).toBeNull();
    });
  });

  describe('resetTransaction', () => {
    it('dispatches RESET_TRANSACTION and resets the state', () => {
      localStorage.setItem('currentTransaction', JSON.stringify({ id: 1, amount: 100 }));

      store.dispatch(resetTransaction());

      const state = store.getState().transaction;
      expect(state).toEqual({
        currentTransaction: null,
        loading: false,
        error: null,
        success: false
      });
      expect(localStorage.getItem('currentTransaction')).toBeNull();
    });
  });

  describe('recoverTransaction', () => {
    it('recovers transaction from localStorage if exists', () => {
      const savedTransaction = { id: 1, amount: 100 };
      localStorage.setItem('currentTransaction', JSON.stringify(savedTransaction));

      store.dispatch(recoverTransaction());

      const state = store.getState().transaction;
      expect(state.currentTransaction).toEqual(savedTransaction);
      expect(state.loading).toBe(false);
      expect(state.error).toBeNull();
      expect(state.success).toBe(true);
    });

    it('does nothing if no transaction exists in localStorage', () => {
      store.dispatch(recoverTransaction());

      const state = store.getState().transaction;
      expect(state.currentTransaction).toBeNull();
      expect(state.loading).toBe(false);
      expect(state.error).toBeNull();
      expect(state.success).toBe(false);
    });
  });
});
