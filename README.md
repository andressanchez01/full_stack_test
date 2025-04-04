# 🧪 Full Stack Test Project

This is a full stack project built with:

- *Frontend:* React.js  
- *Backend:* Ruby with Sinatra  
- *Database:* PostgreSQL  

---

## 📂 Project Structure

```bash
project/
├── frontend/         # ReactJS Application
├── backend/          # API built with Ruby/Sinatra
├── documentation/    # Documentation, diagrams, etc.
└── README.md         # General instructions and documentation
```

---

## 📊 Database Schema (PostgreSQL)
```mermaid
erDiagram
    PRODUCTS {
        int id PK
        string name
        string description
        decimal price
        int stock_quantity
        timestamp created_at
        timestamp updated_at
    }

    CUSTOMERS {
        int id PK
        string name
        string email
        string phone
        string address
        timestamp created_at
        timestamp updated_at
    }

    TRANSACTIONS {
        int id PK
        string transaction_number
        int customer_id FK
        int product_id FK
        int quantity
        decimal base_fee
        decimal delivery_fee
        decimal total_amount
        string status
        string wompi_transaction_id
        timestamp created_at
        timestamp updated_at
    }

    DELIVERIES {
        int id PK
        int transaction_id FK
        string address
        string city
        string postal_code
        string status
        timestamp created_at
        timestamp updated_at
    }

    CUSTOMERS ||--o{ TRANSACTIONS : "places"
    PRODUCTS ||--o{ TRANSACTIONS : "includes"
    TRANSACTIONS ||--o{ DELIVERIES : "has"

```

---

## 📂 Frontend Structure (React + Redux)

```bash
project/frontend/src/
├── actions/                    # Redux actions for API and UI events
│   ├── productActions.js
│   ├── customerActions.js
│   ├── transactionActions.js
│   └── paymentActions.js
├── reducers/                   # Redux reducers for state managment
│   ├── productReducer.js
│   ├── customerReducer.js
│   ├── transactionReducer.js
│   └── index.js
├── components/                 # Reusable UI components
│   ├── ProductList/
│   ├── ProductDetail/
│   ├── PaymentForm/
│   ├── DeliveryForm/
│   ├── PaymentSummary/
│   └── TransactionResult/
├── pages/                      # Route based pages
│   ├── HomePage.js
│   ├── CheckoutPage.js
│   └── ResultPage.js
└── App.js                      # Main app component with routing
```

---
