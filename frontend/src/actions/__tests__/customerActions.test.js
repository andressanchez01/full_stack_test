import axios from 'axios';
import MockAdapter from 'axios-mock-adapter';
import { createTestStore } from '../../testStore';

import {
  SAVE_CUSTOMER_REQUEST,
  SAVE_CUSTOMER_SUCCESS,
  SAVE_CUSTOMER_FAILURE,
  saveCustomer,
} from '../customerActions';

const mockAxios = new MockAdapter(axios);

describe('customerActions', () => {
  let store;

  beforeEach(() => {
    store = createTestStore(); // Usa tu store real con reducers
    mockAxios.reset();
  });

  it('dispatches SAVE_CUSTOMER_SUCCESS when customer is saved successfully', async () => {
    const customerData = { name: 'Juan', email: 'juan@example.com' };
    const responseData = { customerId: 'cust_001', ...customerData };

    mockAxios.onPost('http://18.188.146.79:3000/customers', customerData).reply(200, responseData);

    await store.dispatch(saveCustomer(customerData));

    const state = store.getState().customer;
    expect(state.loading).toBe(false);
    expect(state.data).toEqual(responseData);
    expect(state.error).toBe(null);
  });

  it('dispatches SAVE_CUSTOMER_FAILURE when saving customer fails with server error', async () => {
    const customerData = { name: 'Juan', email: 'juan@example.com' };
    const errorMessage = 'No se pudo guardar el cliente';

    mockAxios.onPost('http://18.188.146.79:3000/customers', customerData).reply(500, {
      message: errorMessage,
    });

    await store.dispatch(saveCustomer(customerData));

    const state = store.getState().customer;
    expect(state.loading).toBe(false);
    expect(state.data).toBe(null);
    expect(state.error).toBe(errorMessage);
  });

  it('dispatches SAVE_CUSTOMER_FAILURE with default error message when no response is received', async () => {
    const customerData = { name: 'Juan', email: 'juan@example.com' };

    mockAxios.onPost('http://18.188.146.79:3000/customers', customerData).networkError();

    await store.dispatch(saveCustomer(customerData));

    const state = store.getState().customer;
    expect(state.loading).toBe(false);
    expect(state.data).toBe(null);
    expect(state.error).toBe('Error al guardar el cliente');
  });
});
