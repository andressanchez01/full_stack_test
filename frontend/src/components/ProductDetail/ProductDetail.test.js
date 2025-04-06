import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import ProductDetail from './ProductDetail';

describe('ProductDetail Component', () => {
  const mockOnAddToCart = jest.fn();

  const product = {
    name: 'Producto de prueba',
    description: 'Este es un producto de prueba.',
    price: 99.99,
    stock_quantity: 10,
  };

  beforeEach(() => {
    mockOnAddToCart.mockClear();
  });

  it('renders "Producto no encontrado" when product is null', () => {
    render(<ProductDetail product={null} onAddToCart={mockOnAddToCart} />);

    expect(screen.getByText(/Producto no encontrado/i)).toBeInTheDocument();
    expect(screen.queryByText(/Precio:/i)).not.toBeInTheDocument();
  });

  it('renders product details correctly when product is provided', () => {
    render(<ProductDetail product={product} onAddToCart={mockOnAddToCart} />);

    expect(screen.getByText(product.name)).toBeInTheDocument();
    expect(screen.getByText(product.description)).toBeInTheDocument();
    expect(screen.getByText(/Precio:/i)).toHaveTextContent(`Precio: $${product.price.toFixed(2)}`);
    expect(screen.getByText(/Stock disponible:/i)).toHaveTextContent(`Stock disponible: ${product.stock_quantity}`);
    expect(screen.getByRole('button', { name: /Agregar al carrito/i })).toBeInTheDocument();
  });

  it('disables the "Agregar al carrito" button when stock is 0', () => {
    const outOfStockProduct = { ...product, stock_quantity: 0 };
    render(<ProductDetail product={outOfStockProduct} onAddToCart={mockOnAddToCart} />);

    const button = screen.getByRole('button', { name: /Sin stock/i });
    expect(button).toBeDisabled();
  });

  it('calls onAddToCart when "Agregar al carrito" button is clicked', () => {
    render(<ProductDetail product={product} onAddToCart={mockOnAddToCart} />);

    const button = screen.getByRole('button', { name: /Agregar al carrito/i });
    fireEvent.click(button);

    expect(mockOnAddToCart).toHaveBeenCalledTimes(1);
    expect(mockOnAddToCart).toHaveBeenCalledWith(product);
  });
});