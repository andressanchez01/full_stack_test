import React from 'react';
import './Footer.css';

const Footer = () => {
  return (
    <footer className="bg-gray-200 text-gray-800 py-6 text-center">
      <div className="container mx-auto">
        <p className="text-sm">
          Desarrollado por <strong>Andres Sanchez</strong> — © {new Date().getFullYear()}
        </p>
        <p className="text-xs mt-1">
          Email: <a href="mailto:andres_sanchez01@hotmail.com" className="underline">andres_sanchez01@hotmail.com</a> | 
          GitHub: <a href="https://github.com/andressanchez01" className="underline ml-1">andressanchez01</a>
        </p>
      </div>
    </footer>
  );
};

export default Footer;
