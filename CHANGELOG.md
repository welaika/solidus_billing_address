0.0.7
* Change: define a js function that can be overrided to manage address fields switch

0.0.6
* Change: use `lastname` and not `last_name` as attribute name. `last_name` is kinda of deprecated
* Fix: remove global variable in javascript
* Change: `company` presence is now required when address type is billig and the customer is business

0.0.4
* Remove the default value ('private') for customer_type. The javascript code will now check the first customer_type radio button
  it finds, if no customer_type is defined

0.0.3
* Forgot to add a migration to remove address_type default value

0.0.2
* We no longer try to duplicate addresses. It goes too out of the solidus way. So a billing address could be also a shipping address.
* Add validations for italian tax code (codice fiscale) and italian einvocing code (codice fatturazione elettronica)
* Personal tax code is shown and required also for business profile. Freelances have both a tax code and a vat number.

0.0.1
* Initial version
