import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import DeliveryForm from './DeliveryForm';

describe('DeliveryForm Component', () => {
  const mockOnSubmit = jest.fn();

  beforeEach(() => {
    mockOnSubmit.mockClear();
  });

  it('renders the form fields correctly', () => {
    render(<DeliveryForm onSubmit={mockOnSubmit} />);

    expect(screen.getByLabelText(/Nombre Completo/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/Email/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/Teléfono/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/Dirección/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/Ciudad/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/Código Postal/i)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /Enviar/i })).toBeInTheDocument();
  });

  it('shows validation errors when fields are empty', () => {
    render(<DeliveryForm onSubmit={mockOnSubmit} />);

    fireEvent.click(screen.getByRole('button', { name: /Enviar/i }));

    expect(screen.getByText(/El nombre es requerido/i)).toBeInTheDocument();
    expect(screen.getByText(/El email es requerido/i)).toBeInTheDocument();
    expect(screen.getByText(/El teléfono es requerido/i)).toBeInTheDocument();
    expect(screen.getByText(/La dirección es requerida/i)).toBeInTheDocument();
    expect(screen.getByText(/La ciudad es requerida/i)).toBeInTheDocument();
    expect(screen.getByText(/El código postal es requerido/i)).toBeInTheDocument();
    expect(mockOnSubmit).not.toHaveBeenCalled();
  });

  it('shows validation error for invalid email', () => {
    render(<DeliveryForm onSubmit={mockOnSubmit} />);

    fireEvent.change(screen.getByLabelText(/Email/i), { target: { value: 'invalid-email' } });
    fireEvent.click(screen.getByRole('button', { name: /Enviar/i }));

    expect(screen.getByText(/Email inválido/i)).toBeInTheDocument();
    expect(mockOnSubmit).not.toHaveBeenCalled();
  });

  it('shows validation error for invalid phone number', () => {
    render(<DeliveryForm onSubmit={mockOnSubmit} />);

    fireEvent.change(screen.getByLabelText(/Teléfono/i), { target: { value: '12345' } });
    fireEvent.click(screen.getByRole('button', { name: /Enviar/i }));

    expect(screen.getByText(/Teléfono inválido \(10 dígitos\)/i)).toBeInTheDocument();
    expect(mockOnSubmit).not.toHaveBeenCalled();
  });

  it('calls onSubmit with correct data when the form is valid', () => {
    render(<DeliveryForm onSubmit={mockOnSubmit} />);

    fireEvent.change(screen.getByLabelText(/Nombre Completo/i), { target: { value: 'Juan Pérez' } });
    fireEvent.change(screen.getByLabelText(/Email/i), { target: { value: 'juan@ejemplo.com' } });
    fireEvent.change(screen.getByLabelText(/Teléfono/i), { target: { value: '1234567890' } });
    fireEvent.change(screen.getByLabelText(/Dirección/i), { target: { value: 'Calle Principal #123' } });
    fireEvent.change(screen.getByLabelText(/Ciudad/i), { target: { value: 'Bogotá' } });
    fireEvent.change(screen.getByLabelText(/Código Postal/i), { target: { value: '110111' } });

    fireEvent.click(screen.getByRole('button', { name: /Enviar/i }));

    expect(mockOnSubmit).toHaveBeenCalledTimes(1);
    expect(mockOnSubmit).toHaveBeenCalledWith({
      name: 'Juan Pérez',
      email: 'juan@ejemplo.com',
      phone: '1234567890',
      address: 'Calle Principal #123',
      city: 'Bogotá',
      postalCode: '110111',
    });
  });
});