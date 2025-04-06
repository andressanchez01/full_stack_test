import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import PaymentSummary from './PaymentSummary';

describe('PaymentSummary Component', () => {
  const mockOnConfirm = jest.fn();
  const mockOnCancel = jest.fn();

  const paymentData = {
    id: '12345',
    status: 'APPROVED',
    total_amount: 15000, 
    currency: 'USD',
  };

  beforeEach(() => {
    mockOnConfirm.mockClear();
    mockOnCancel.mockClear();
  });

  it('renders "No payment information available" when paymentData is null', () => {
    render(<PaymentSummary paymentData={null} onConfirm={mockOnConfirm} onCancel={mockOnCancel} />);

    expect(screen.getByText(/No payment information available/i)).toBeInTheDocument();
    expect(screen.queryByText(/Transaction ID:/i)).not.toBeInTheDocument();
  });

  it('renders payment details correctly when paymentData is provided', () => {
    render(<PaymentSummary paymentData={paymentData} onConfirm={mockOnConfirm} onCancel={mockOnCancel} />);

    expect(screen.getByText(/Transaction ID:/i)).toBeInTheDocument();
    expect(screen.getByText(/12345/i)).toBeInTheDocument();
    expect(screen.getByText(/Status:/i)).toBeInTheDocument();
    expect(screen.getByText(/APPROVED/i)).toBeInTheDocument();
    expect(screen.getByText(/Total Amount:/i)).toBeInTheDocument();
    expect(screen.getByText(/\$150.00/i)).toBeInTheDocument(); // Total en formato moneda
    expect(screen.getByText(/Currency:/i)).toBeInTheDocument();
    expect(screen.getByText(/USD/i)).toBeInTheDocument();
  });

  it('calls onConfirm when the Confirm button is clicked', () => {
    render(<PaymentSummary paymentData={paymentData} onConfirm={mockOnConfirm} onCancel={mockOnCancel} />);

    fireEvent.click(screen.getByRole('button', { name: /Confirm/i }));

    expect(mockOnConfirm).toHaveBeenCalledTimes(1);
  });

  it('calls onCancel when the Cancel button is clicked', () => {
    render(<PaymentSummary paymentData={paymentData} onConfirm={mockOnConfirm} onCancel={mockOnCancel} />);

    fireEvent.click(screen.getByRole('button', { name: /Cancel/i }));

    expect(mockOnCancel).toHaveBeenCalledTimes(1);
  });
});