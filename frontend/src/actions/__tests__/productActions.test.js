import axios from 'axios';
import MockAdapter from 'axios-mock-adapter';
import { createTestStore } from '../../testStore';

import {
  FETCH_PRODUCTS_REQUEST,
  FETCH_PRODUCTS_SUCCESS,
  FETCH_PRODUCTS_FAILURE,
  FETCH_PRODUCT_DETAIL_REQUEST,
  FETCH_PRODUCT_DETAIL_SUCCESS,
  FETCH_PRODUCT_DETAIL_FAILURE,
  fetchProducts,
  fetchProductDetail,
} from '../productActions';

const mockAxios = new MockAdapter(axios);

describe('productActions', () => {
  let store;

  beforeEach(() => {
    store = createTestStore();
    mockAxios.reset();
  });

  describe('fetchProducts', () => {
    it('dispatches FETCH_PRODUCTS_SUCCESS when products are fetched successfully', async () => {
      const products = [
        { id: 1, name: 'Producto 1' },
        { id: 2, name: 'Producto 2' }
      ];

      mockAxios.onGet('http://localhost:4567/api/products').reply(200, { data: products });

      await store.dispatch(fetchProducts());

      const state = store.getState().products;
      expect(state.loading).toBe(false);
      expect(state.items).toEqual(products);
      expect(state.error).toBe(null);
    });

    it('dispatches FETCH_PRODUCTS_FAILURE when fetching products fails', async () => {
      mockAxios.onGet('http://localhost:4567/api/products').networkError();

      await store.dispatch(fetchProducts());

      const state = store.getState().products;
      expect(state.loading).toBe(false);
      expect(state.items).toEqual([]);
      expect(state.error).toBeTruthy();
    });
  });

  describe('fetchProductDetail', () => {
    it('dispatches FETCH_PRODUCT_DETAIL_SUCCESS when product detail is fetched successfully', async () => {
      const product = { id: 1, name: 'Producto 1', description: 'Detalles' };

      mockAxios.onGet('http://localhost:4567/api/products/1').reply(200, { data: product });

      await store.dispatch(fetchProductDetail(1));

      const state = store.getState().products;
      expect(state.loadingDetail).toBe(false);
      expect(state.detail).toEqual(product);
      expect(state.errorDetail).toBe(null);
    });

    it('dispatches FETCH_PRODUCT_DETAIL_FAILURE when fetching product detail fails', async () => {
      mockAxios.onGet('http://localhost:4567/api/products/1').networkError();

      await store.dispatch(fetchProductDetail(1));

      const state = store.getState().products;
      expect(state.loadingDetail).toBe(false);
      expect(state.detail).toBe(null);
      expect(state.errorDetail).toBeTruthy();
    });
  });
});
