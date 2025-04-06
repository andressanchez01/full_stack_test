import {
  FETCH_PRODUCTS_REQUEST,
  FETCH_PRODUCTS_SUCCESS,
  FETCH_PRODUCTS_FAILURE,
  FETCH_PRODUCT_DETAIL_REQUEST,
  FETCH_PRODUCT_DETAIL_SUCCESS,
  FETCH_PRODUCT_DETAIL_FAILURE,
} from '../actions/productActions';

const initialState = {
  loading: false,
  items: [],
  error: null,
  loadingDetail: false,
  detail: null,
  errorDetail: null,
};

const productReducer = (state = initialState, action) => {
  switch (action.type) {
    case FETCH_PRODUCTS_REQUEST:
      return { ...state, loading: true, error: null };
    case FETCH_PRODUCTS_SUCCESS:
      return { ...state, loading: false, items: action.payload, error: null };
    case FETCH_PRODUCTS_FAILURE:
      return { ...state, loading: false, items: [], error: action.payload };
    case FETCH_PRODUCT_DETAIL_REQUEST:
      return { ...state, loadingDetail: true, errorDetail: null };
    case FETCH_PRODUCT_DETAIL_SUCCESS:
      return { ...state, loadingDetail: false, detail: action.payload, errorDetail: null };
    case FETCH_PRODUCT_DETAIL_FAILURE:
      return { ...state, loadingDetail: false, detail: null, errorDetail: action.payload };
    default:
      return state;
  }
};

export default productReducer;