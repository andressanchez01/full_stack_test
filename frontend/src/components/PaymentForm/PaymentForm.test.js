import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import PaymentForm from './PaymentForm';

describe('PaymentForm Component', () => {
  const mockOnSubmit = jest.fn();

  beforeEach(() => {
    mockOnSubmit.mockClear();
  });

  it('renders the form fields correctly', () => {
    render(<PaymentForm onSubmit={mockOnSubmit} />);

    expect(screen.getByLabelText(/Número de Tarjeta/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/Titular de la Tarjeta/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/Mes de Expiración/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/Año de Expiración/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/CVV/i)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /Continuar/i })).toBeInTheDocument();
  });

  it('shows validation errors when fields are empty', () => {
    render(<PaymentForm onSubmit={mockOnSubmit} />);

    fireEvent.click(screen.getByRole('button', { name: /Continuar/i }));

    expect(screen.getByText(/El número de tarjeta es requerido/i)).toBeInTheDocument();
    expect(screen.getByText(/El nombre del titular es requerido/i)).toBeInTheDocument();
    expect(screen.getByText(/El mes es requerido/i)).toBeInTheDocument();
    expect(screen.getByText(/El año es requerido/i)).toBeInTheDocument();
    expect(screen.getByText(/El CVV es requerido/i)).toBeInTheDocument();
    expect(mockOnSubmit).not.toHaveBeenCalled();
  });

  it('shows validation error for invalid card number', () => {
    render(<PaymentForm onSubmit={mockOnSubmit} />);

    fireEvent.change(screen.getByLabelText(/Número de Tarjeta/i), { target: { value: '12345' } });
    fireEvent.click(screen.getByRole('button', { name: /Continuar/i }));

    expect(screen.getByText(/El número de tarjeta debe tener entre 13 y 16 dígitos/i)).toBeInTheDocument();
    expect(mockOnSubmit).not.toHaveBeenCalled();
  });

  it('shows validation error for invalid expiry month', () => {
    render(<PaymentForm onSubmit={mockOnSubmit} />);

    fireEvent.change(screen.getByLabelText(/Mes de Expiración/i), { target: { value: '13' } });
    fireEvent.click(screen.getByRole('button', { name: /Continuar/i }));

    expect(screen.getByText(/Mes inválido/i)).toBeInTheDocument();
    expect(mockOnSubmit).not.toHaveBeenCalled();
  });

  it('shows validation error for invalid expiry year', () => {
    render(<PaymentForm onSubmit={mockOnSubmit} />);

    fireEvent.change(screen.getByLabelText(/Año de Expiración/i), { target: { value: '20' } });
    fireEvent.click(screen.getByRole('button', { name: /Continuar/i }));

    expect(screen.getByText(/Año inválido/i)).toBeInTheDocument();
    expect(mockOnSubmit).not.toHaveBeenCalled();
  });

  it('shows validation error for invalid CVV', () => {
    render(<PaymentForm onSubmit={mockOnSubmit} />);

    fireEvent.change(screen.getByLabelText(/CVV/i), { target: { value: '12' } });
    fireEvent.click(screen.getByRole('button', { name: /Continuar/i }));

    expect(screen.getByText(/El CVV debe tener 3 o 4 dígitos/i)).toBeInTheDocument();
    expect(mockOnSubmit).not.toHaveBeenCalled();
  });

  it('calls onSubmit with correct data when the form is valid', () => {
    render(<PaymentForm onSubmit={mockOnSubmit} />);

    fireEvent.change(screen.getByLabelText(/Número de Tarjeta/i), { target: { value: '4111111111111111' } });
    fireEvent.change(screen.getByLabelText(/Titular de la Tarjeta/i), { target: { value: 'Juan Pérez' } });
    fireEvent.change(screen.getByLabelText(/Mes de Expiración/i), { target: { value: '12' } });
    fireEvent.change(screen.getByLabelText(/Año de Expiración/i), { target: { value: '30' } });
    fireEvent.change(screen.getByLabelText(/CVV/i), { target: { value: '123' } });

    fireEvent.click(screen.getByRole('button', { name: /Continuar/i }));

    expect(mockOnSubmit).toHaveBeenCalledTimes(1);
    expect(mockOnSubmit).toHaveBeenCalledWith({
      cardNumber: '4111111111111111',
      cardHolder: 'Juan Pérez',
      expiryMonth: '12',
      expiryYear: '30',
      cvv: '123',
    });
  });
});