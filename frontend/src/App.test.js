import React from 'react';
import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import { Provider } from 'react-redux';
import store from './store';

import App from './App';

jest.mock('./pages/HomePage', () => () => <div>Home Page</div>);
jest.mock('./pages/CheckoutPage', () => () => <div>Checkout Page</div>);
jest.mock('./pages/ResultPage', () => () => <div>Result Page</div>);
jest.mock('./pages/ProductDetailPage', () => () => <div>Product Detail Page</div>);

describe('App Component', () => {
  const renderWithRouter = (initialEntries) => {
    return render(
      <Provider store={store}>
        <App Router={({ children }) => <MemoryRouter initialEntries={initialEntries}>{children}</MemoryRouter>} />
      </Provider>
    );
  };

  it('renders the HomePage component for the root route', () => {
    renderWithRouter(['/']);
    expect(screen.getByText('Home Page')).toBeInTheDocument();
  });

  it('renders the CheckoutPage component for the /checkout route', () => {
    renderWithRouter(['/checkout']);
    expect(screen.getByText('Checkout Page')).toBeInTheDocument();
  });

  it('renders the ResultPage component for the /result route', () => {
    renderWithRouter(['/result']);
    expect(screen.getByText('Result Page')).toBeInTheDocument();
  });

  it('renders the ProductDetailPage component for the /product/:productId route', () => {
    renderWithRouter(['/product/123']);
    expect(screen.getByText('Product Detail Page')).toBeInTheDocument();
  });

  it('renders a "not found" message for an unknown route', () => {
    renderWithRouter(['/unknown']);
    expect(screen.queryByText('Home Page')).not.toBeInTheDocument();
    expect(screen.queryByText('Checkout Page')).not.toBeInTheDocument();
    expect(screen.queryByText('Result Page')).not.toBeInTheDocument();
    expect(screen.queryByText('Product Detail Page')).not.toBeInTheDocument();
  });
});