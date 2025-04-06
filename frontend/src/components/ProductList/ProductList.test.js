import React from 'react';
import { render, screen } from '@testing-library/react';
import { BrowserRouter as Router } from 'react-router-dom';
import ProductList from './ProductList';

describe('ProductList Component', () => {
  const products = [
    {
      id: 1,
      name: 'Producto 1',
      description: 'Descripción del producto 1',
      price: 100.0,
      stock_quantity: 5,
    },
    {
      id: 2,
      name: 'Producto 2',
      description: 'Descripción del producto 2',
      price: 200.0,
      stock_quantity: 0,
    },
  ];

  it('renders "No hay productos disponibles" when the product list is empty', () => {
    render(
      <Router>
        <ProductList products={[]} />
      </Router>
    );

    expect(screen.getByText(/No hay productos disponibles/i)).toBeInTheDocument();
  });

  it('renders the product list correctly', () => {
    render(
      <Router>
        <ProductList products={products} />
      </Router>
    );

    // Verifica que los nombres de los productos se rendericen
    expect(screen.getByText(/Producto 1/i)).toBeInTheDocument();
    expect(screen.getByText(/Producto 2/i)).toBeInTheDocument();

    // Verifica que las descripciones de los productos se rendericen
    expect(screen.getByText(/Descripción del producto 1/i)).toBeInTheDocument();
    expect(screen.getByText(/Descripción del producto 2/i)).toBeInTheDocument();

    // Verifica que los precios se rendericen correctamente
    expect(screen.getByText(/\$100.00/i)).toBeInTheDocument();
    expect(screen.getByText(/\$200.00/i)).toBeInTheDocument();

    // Verifica que el stock se renderice correctamente
    expect(screen.getByText(/Stock: 5/i)).toBeInTheDocument();
    expect(screen.getByText(/Stock: 0/i)).toBeInTheDocument();

    // Verifica que los botones "Ver producto" se rendericen
    expect(screen.getAllByText(/Ver producto/i)).toHaveLength(2);
  });

  it('renders links to the correct product detail pages', () => {
    render(
      <Router>
        <ProductList products={products} />
      </Router>
    );

    const links = screen.getAllByRole('link', { name: /Ver producto/i });
    expect(links[0]).toHaveAttribute('href', '/product/1');
    expect(links[1]).toHaveAttribute('href', '/product/2');
  });
});