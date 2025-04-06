import axios from 'axios';
import MockAdapter from 'axios-mock-adapter';
import { createTestStore } from '../../testStore'; // Importa el store real
import {
  PROCESS_PAYMENT_REQUEST,
  PROCESS_PAYMENT_SUCCESS,
  PROCESS_PAYMENT_FAILURE,
  processPayment,
} from '../paymentActions';

const mockAxios = new MockAdapter(axios);

describe('paymentActions', () => {
  let store;

  beforeEach(() => {
    store = createTestStore(); // Usa el store real
    mockAxios.reset();
  });

  it('dispatches PROCESS_PAYMENT_SUCCESS when payment is processed successfully', async () => {
    const paymentData = { cardNumber: '4111111111111111', amount: 100 };
    const responseData = { transactionId: '12345', status: 'APPROVED' };

    mockAxios.onPost('http://localhost:4567/payments', paymentData).reply(200, responseData);

    await store.dispatch(processPayment(paymentData));

    const state = store.getState().payment; // Obtén el estado actualizado
    expect(state.loading).toBe(false);
    expect(state.data).toEqual(responseData);
    expect(state.error).toBe(null);
  });

  it('dispatches PROCESS_PAYMENT_FAILURE when payment processing fails', async () => {
    const paymentData = { cardNumber: '4111111111111111', amount: 100 };
    const errorMessage = 'Error al procesar el pago';

    mockAxios.onPost('http://localhost:4567/payments', paymentData).reply(500, {
      message: errorMessage,
    });

    await store.dispatch(processPayment(paymentData));

    const state = store.getState().payment; // Obtén el estado actualizado
    expect(state.loading).toBe(false);
    expect(state.data).toBe(null);
    expect(state.error).toBe(errorMessage);
  });

  it('dispatches PROCESS_PAYMENT_FAILURE with default error message when no response is received', async () => {
    const paymentData = { cardNumber: '4111111111111111', amount: 100 };

    mockAxios.onPost('http://localhost:4567/payments', paymentData).networkError();

    await store.dispatch(processPayment(paymentData));

    const state = store.getState().payment; // Obtén el estado actualizado
    expect(state.loading).toBe(false);
    expect(state.data).toBe(null);
    expect(state.error).toBe('Error al procesar el pago');
  });
});