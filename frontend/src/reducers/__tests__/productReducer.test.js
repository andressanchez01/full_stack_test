// src/reducers/__tests__/productReducer.test.js
import productReducer from '../productReducer';
import {
  FETCH_PRODUCTS_REQUEST,
  FETCH_PRODUCTS_SUCCESS,
  FETCH_PRODUCTS_FAILURE,
  FETCH_PRODUCT_DETAIL_REQUEST,
  FETCH_PRODUCT_DETAIL_SUCCESS,
  FETCH_PRODUCT_DETAIL_FAILURE
} from '../../actions/productActions';

describe('productReducer', () => {
  const initialState = {
    products: [],
    currentProduct: null,
    loading: false,
    error: null
  };

  it('should return the initial state', () => {
    expect(productReducer(undefined, {})).toEqual(initialState);
  });

  it('should handle FETCH_PRODUCTS_REQUEST', () => {
    const action = { type: FETCH_PRODUCTS_REQUEST };
    const expectedState = {
      ...initialState,
      loading: true,
      error: null
    };
    expect(productReducer(initialState, action)).toEqual(expectedState);
  });

  it('should handle FETCH_PRODUCTS_SUCCESS', () => {
    const mockProducts = [{ id: 1, name: 'Producto A' }];
    const action = { type: FETCH_PRODUCTS_SUCCESS, payload: mockProducts };
    const expectedState = {
      ...initialState,
      loading: false,
      products: mockProducts
    };
    expect(productReducer(initialState, action)).toEqual(expectedState);
  });

  it('should handle FETCH_PRODUCTS_FAILURE', () => {
    const error = 'Error al obtener productos';
    const action = { type: FETCH_PRODUCTS_FAILURE, payload: error };
    const expectedState = {
      ...initialState,
      loading: false,
      error
    };
    expect(productReducer(initialState, action)).toEqual(expectedState);
  });

  it('should handle FETCH_PRODUCT_DETAIL_REQUEST', () => {
    const action = { type: FETCH_PRODUCT_DETAIL_REQUEST };
    const expectedState = {
      ...initialState,
      loading: true,
      error: null
    };
    expect(productReducer(initialState, action)).toEqual(expectedState);
  });

  it('should handle FETCH_PRODUCT_DETAIL_SUCCESS', () => {
    const product = { id: 2, name: 'Producto Detalle' };
    const action = { type: FETCH_PRODUCT_DETAIL_SUCCESS, payload: product };
    const expectedState = {
      ...initialState,
      loading: false,
      currentProduct: product
    };
    expect(productReducer(initialState, action)).toEqual(expectedState);
  });

  it('should handle FETCH_PRODUCT_DETAIL_FAILURE', () => {
    const error = 'Error al obtener el detalle';
    const action = { type: FETCH_PRODUCT_DETAIL_FAILURE, payload: error };
    const expectedState = {
      ...initialState,
      loading: false,
      error
    };
    expect(productReducer(initialState, action)).toEqual(expectedState);
  });
});
