import React from 'react';
import { BrowserRouter as Router } from 'react-router-dom';
import { render } from '@testing-library/react';

const renderWithRouter = (ui, options) => {
  return render(<Router>{ui}</Router>, options);
};

export * from '@testing-library/react';
export { renderWithRouter };
