import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import { MemoryRouter, useNavigate } from 'react-router-dom';
import ProductDetail from './ProductDetail';

jest.mock('react-router-dom', () => ({
  ...jest.requireActual('react-router-dom'),
  useNavigate: jest.fn(),
}));

describe('ProductDetail Component', () => {
  const mockNavigate = jest.fn();
  const mockProduct = {
    name: 'Taza Ruby',
    description: 'Una taza para desarrolladores.',
    price: 15000,
    stock_quantity: 10,
    image_url: 'https://example.com/taza-ruby.jpg',
  };

  beforeEach(() => {
    jest.clearAllMocks();
    useNavigate.mockReturnValue(mockNavigate);
  });

  it('renders product details correctly', () => {
    render(
      <MemoryRouter>
        <ProductDetail product={mockProduct} />
      </MemoryRouter>
    );

    expect(screen.getByText(mockProduct.name)).toBeInTheDocument();
    expect(screen.getByText(mockProduct.description)).toBeInTheDocument();
    expect(screen.getByText(`Precio: $${mockProduct.price.toFixed(2)}`)).toBeInTheDocument();
    expect(screen.getByText(`Stock disponible: ${mockProduct.stock_quantity}`)).toBeInTheDocument();
    expect(screen.getByAltText(mockProduct.name)).toBeInTheDocument();
  });

  it('renders a placeholder image when no image URL is provided', () => {
    const productWithoutImage = { ...mockProduct, image_url: null };

    render(
      <MemoryRouter>
        <ProductDetail product={productWithoutImage} />
      </MemoryRouter>
    );

    expect(screen.getByText('Sin imagen')).toBeInTheDocument();
  });

  it('disables the "Pagar con tarjeta de crédito" button when stock is 0', () => {
    const outOfStockProduct = { ...mockProduct, stock_quantity: 0 };

    render(
      <MemoryRouter>
        <ProductDetail product={outOfStockProduct} />
      </MemoryRouter>
    );

    const button = screen.getByText('Sin stock');
    expect(button).toBeDisabled();
  });

  it('updates the quantity when the input value changes', () => {
    render(
      <MemoryRouter>
        <ProductDetail product={mockProduct} />
      </MemoryRouter>
    );

    const quantityInput = screen.getByLabelText(/Cantidad:/i);
    expect(quantityInput.value).toBe('1'); // Valor inicial

    fireEvent.change(quantityInput, { target: { value: '5' } });
    expect(quantityInput.value).toBe('5');
  });

  it('navigates to the checkout page with the correct state when "Pagar con tarjeta de crédito" is clicked', () => {
    render(
      <MemoryRouter>
        <ProductDetail product={mockProduct} />
      </MemoryRouter>
    );

    const button = screen.getByText('Pagar con tarjeta de crédito');
    fireEvent.click(button);

    expect(mockNavigate).toHaveBeenCalledWith('/checkout', {
      state: {
        product: mockProduct,
        quantity: 1,
      },
    });
  });

  it('renders "Producto no encontrado" when no product is provided', () => {
    render(
      <MemoryRouter>
        <ProductDetail product={null} />
      </MemoryRouter>
    );

    expect(screen.getByText('Producto no encontrado.')).toBeInTheDocument();
  });
});