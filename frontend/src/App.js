import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import { Provider } from 'react-redux';
import store from './store';

import HomePage from './pages/HomePage';
import CheckoutPage from './pages/CheckoutPage';
import ResultPage from './pages/ResultPage';

function App() {
  return (
    <Provider store={store}>
      <Router>
        <div className="App">
          <Switch>
            <Route exact path="/" component={HomePage} />
            <Route path="/checkout" component={CheckoutPage} />
            <Route path="/result" component={ResultPage} />
          </Switch>
        </div>
      </Router>
    </Provider>
  );
}

export default App;
