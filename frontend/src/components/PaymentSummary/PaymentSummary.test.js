import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import PaymentSummary from './PaymentSummary';

describe('PaymentSummary Component', () => {
  const mockProduct = {
    name: 'Taza Ruby',
    price: 10000,
  };

  const mockPaymentData = {
    base_fee: 4000,
    delivery_fee: 9000,
    total_amount: 23000,
  };

  const mockDeliveryData = {
    address: 'Carrera 59 # 70c - 28',
    city: 'Bogotá',
  };

  const mockOnConfirm = jest.fn();
  const mockOnCancel = jest.fn();

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('renders the payment summary with complete data', () => {
    render(
      <PaymentSummary
        product={mockProduct}
        quantity={2}
        paymentData={mockPaymentData}
        deliveryData={mockDeliveryData}
        onConfirm={mockOnConfirm}
        onCancel={mockOnCancel}
      />
    );

    // Verifica que los datos del producto se rendericen correctamente
    expect(screen.getByText(/Nombre:/i)).toBeInTheDocument();
    expect(screen.getByText('Taza Ruby')).toBeInTheDocument();
    expect(screen.getByText(/Precio unitario:/i)).toBeInTheDocument();
    expect(screen.getByText('$10,000')).toBeInTheDocument();
    expect(screen.getByText(/Cantidad:/i)).toBeInTheDocument();
    expect(screen.getByText('2')).toBeInTheDocument();
    expect(screen.getByText(/Subtotal producto:/i)).toBeInTheDocument();
    expect(screen.getByText('$20,000')).toBeInTheDocument();

    // Verifica que las tarifas se rendericen correctamente
    expect(screen.getByText(/Tarifa base:/i)).toBeInTheDocument();
    expect(screen.getByText('$4,000')).toBeInTheDocument();
    expect(screen.getByText(/Costo de envío:/i)).toBeInTheDocument();
    expect(screen.getByText('$9,000')).toBeInTheDocument();
    expect(screen.getByText(/Total:/i)).toBeInTheDocument();
    expect(screen.getByText('$23,000')).toBeInTheDocument();

    // Verifica que los datos de envío se rendericen correctamente
    expect(screen.getByText(/Dirección:/i)).toBeInTheDocument();
    expect(screen.getByText('Carrera 59 # 70c - 28')).toBeInTheDocument();
    expect(screen.getByText(/Ciudad:/i)).toBeInTheDocument();
    expect(screen.getByText('Bogotá')).toBeInTheDocument();

    // Verifica que los botones se rendericen
    expect(screen.getByRole('button', { name: /Confirmar y pagar/i })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /Cancelar/i })).toBeInTheDocument();
  });

  it('renders a message when data is incomplete', () => {
    render(<PaymentSummary product={null} quantity={null} paymentData={null} deliveryData={null} />);

    expect(screen.getByText(/Información incompleta para mostrar el resumen./i)).toBeInTheDocument();
  });

  it('calls onConfirm when the confirm button is clicked', () => {
    render(
      <PaymentSummary
        product={mockProduct}
        quantity={2}
        paymentData={mockPaymentData}
        deliveryData={mockDeliveryData}
        onConfirm={mockOnConfirm}
        onCancel={mockOnCancel}
      />
    );

    const confirmButton = screen.getByRole('button', { name: /Confirmar y pagar/i });
    fireEvent.click(confirmButton);

    expect(mockOnConfirm).toHaveBeenCalledTimes(1);
  });

  it('calls onCancel when the cancel button is clicked', () => {
    render(
      <PaymentSummary
        product={mockProduct}
        quantity={2}
        paymentData={mockPaymentData}
        deliveryData={mockDeliveryData}
        onConfirm={mockOnConfirm}
        onCancel={mockOnCancel}
      />
    );

    const cancelButton = screen.getByRole('button', { name: /Cancelar/i });
    fireEvent.click(cancelButton);

    expect(mockOnCancel).toHaveBeenCalledTimes(1);
  });
});