import React from 'react';
import { render, screen } from '@testing-library/react';
import { MemoryRouter } from 'react-router-dom';
import ProductList from './ProductList';

describe('ProductList Component', () => {
  const mockProducts = [
    {
      id: 1,
      name: 'Taza Ruby',
      description: 'Una taza para desarrolladores.',
      price: 15000,
      stock_quantity: 10,
      image_url: 'https://example.com/taza-ruby.jpg',
    },
    {
      id: 2,
      name: 'Camiseta JavaScript',
      description: 'Camiseta con diseño de JavaScript.',
      price: 25000,
      stock_quantity: 5,
      image_url: null,
    },
  ];

  it('renders a list of products correctly', () => {
    render(
      <MemoryRouter>
        <ProductList products={mockProducts} />
      </MemoryRouter>
    );

    // Verifica que los productos se rendericen correctamente
    expect(screen.getByText('Taza Ruby')).toBeInTheDocument();
    expect(screen.getByText('Una taza para desarrolladores.')).toBeInTheDocument();
    expect(screen.getByText('$15000.00')).toBeInTheDocument();
    expect(screen.getByText('Stock: 10')).toBeInTheDocument();
    expect(screen.getByAltText('Taza Ruby')).toBeInTheDocument();

    expect(screen.getByText('Camiseta JavaScript')).toBeInTheDocument();
    expect(screen.getByText('Camiseta con diseño de JavaScript.')).toBeInTheDocument();
    expect(screen.getByText('$25000.00')).toBeInTheDocument();
    expect(screen.getByText('Stock: 5')).toBeInTheDocument();
    expect(screen.getByText('Sin imagen')).toBeInTheDocument();
  });

  it('renders a placeholder image when no image URL is provided', () => {
    render(
      <MemoryRouter>
        <ProductList products={mockProducts} />
      </MemoryRouter>
    );

    expect(screen.getByText('Sin imagen')).toBeInTheDocument();
  });

  it('renders a message when the product list is empty', () => {
    render(
      <MemoryRouter>
        <ProductList products={[]} />
      </MemoryRouter>
    );

    expect(screen.getByText('No hay productos disponibles.')).toBeInTheDocument();
  });

  it('renders a message when no products prop is provided', () => {
    render(
      <MemoryRouter>
        <ProductList products={null} />
      </MemoryRouter>
    );

    expect(screen.getByText('No hay productos disponibles.')).toBeInTheDocument();
  });

  it('renders a "Ver producto" link for each product', () => {
    render(
      <MemoryRouter>
        <ProductList products={mockProducts} />
      </MemoryRouter>
    );

    const links = screen.getAllByText('Ver producto');
    expect(links).toHaveLength(mockProducts.length);
    expect(links[0]).toHaveAttribute('href', '/product/1');
    expect(links[1]).toHaveAttribute('href', '/product/2');
  });
});