import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import TransactionResult from './TransactionResult';

describe('TransactionResult Component', () => {
  const mockOnBackToHome = jest.fn();

  beforeEach(() => {
    mockOnBackToHome.mockClear();
  });

  it('renders success message when success is true', () => {
    render(
      <TransactionResult
        success={true}
        message="El pago se realizó correctamente."
        onBackToHome={mockOnBackToHome}
      />
    );

    expect(screen.getByText(/¡Pago exitoso!/i)).toBeInTheDocument();
    expect(screen.getByText(/El pago se realizó correctamente./i)).toBeInTheDocument();
    expect(screen.getByText('✅')).toBeInTheDocument();
  });

  it('renders error message when success is false', () => {
    render(
      <TransactionResult
        success={false}
        message="Hubo un problema con el pago."
        onBackToHome={mockOnBackToHome}
      />
    );

    expect(screen.getByText(/Ocurrió un error/i)).toBeInTheDocument();
    expect(screen.getByText(/Hubo un problema con el pago./i)).toBeInTheDocument();
    expect(screen.getByText('❌')).toBeInTheDocument();
  });

  it('calls onBackToHome when the "Volver al inicio" button is clicked', () => {
    render(
      <TransactionResult
        success={true}
        message="El pago se realizó correctamente."
        onBackToHome={mockOnBackToHome}
      />
    );

    const button = screen.getByRole('button', { name: /Volver al inicio/i });
    fireEvent.click(button);

    expect(mockOnBackToHome).toHaveBeenCalledTimes(1);
  });
});