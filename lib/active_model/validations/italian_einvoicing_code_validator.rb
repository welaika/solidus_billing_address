# frozen_string_literal: true

class ItalianEinvoicingCodeValidator < ActiveModel::EachValidator
  FORMAT = Regexp.compile('\A[A-Z0-9]{7}\z')

  def validate_each(record, attribute, value)
    return if options[:allow_blank] && value.blank?

    record.errors.add(attribute, :invalid) unless value.match(FORMAT)
  end
end
