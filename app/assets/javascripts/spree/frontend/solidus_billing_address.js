// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/frontend/all.js'
//
//
Spree.ready(function($) {
  Spree.toggleAddressFields = function (customerType) {
    if (customerType === 'business') {
      $('#order_bill_address_attributes_vat_number').prop('disabled', false);
      $('#bvat_number').show();

      $('#order_bill_address_attributes_billing_email').prop('disabled', false);
      $('#bbilling_email').show();

      $('#order_bill_address_attributes_einvoicing_code').prop('disabled', false);
      $('#beinvoicing_code').show();

      $('#order_bill_address_attributes_company').prop('disabled', false);
      $('#bcompany').show();
    } else if (customerType === 'private') {
      $('#order_bill_address_attributes_vat_number').prop('disabled', true);
      $('#bvat_number').hide();

      $('#order_bill_address_attributes_billing_email').prop('disabled', true);
      $('#bbilling_email').hide();

      $('#order_bill_address_attributes_einvoicing_code').prop('disabled', true);
      $('#beinvoicing_code').hide();

      $('#order_bill_address_attributes_company').prop('disabled', true);
      $('#bcompany').hide();
    }
  };

  if ($("form#checkout_form_address").is("*")) {
    var $customerTypeRadios = $("input[name='order[bill_address_attributes][customer_type]'][type='radio']")

    $customerTypeRadios.change(function() {
      Spree.toggleAddressFields($customerTypeRadios.filter(':checked').val());
    });

    if ($customerTypeRadios.filter(':checked').length === 0) {
      $customerTypeRadios.first().prop('checked', true);
    }

    Spree.toggleAddressFields($customerTypeRadios.filter(':checked').val());
  }
});
