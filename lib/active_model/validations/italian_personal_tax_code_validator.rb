# frozen_string_literal: true

# Thanks to https://github.com/freego/italian_job

class ItalianPersonalTaxCodeValidator < ActiveModel::EachValidator
  REGEX = Regexp.compile('\A[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]\z')
  BUSINESS_REGEX = Regexp.compile('\A(?:IT)?[0-9]{11}\z')

  DISPARI = [1, 0, 5, 7, 9, 13, 15, 17, 19, 21, 1, 0, 5, 7, 9, 13, 15, 17, 19, 21,
             2, 4, 18, 20, 11, 3, 6, 8, 12, 14, 16, 10, 22, 25, 24, 23].freeze

  def validate_each(record, attribute, value)
    return if options[:allow_blank] && value.blank?
    return if allow_vat_numbers?(record) && value.match(BUSINESS_REGEX)

    record.errors.add(attribute, :invalid) unless control_code_valid?(value)
  end

  private

  def allow_vat_numbers?(record)
    return true if options[:allow_vat_numbers] == true
    return true if options[:allow_vat_numbers].respond_to?(:call) && options[:allow_vat_numbers].call(record)

    false
  end

  def control_code_valid?(value) # rubocop:disable Metrics/AbcSize
    return false unless value.match(REGEX)

    odds = []
    evens = []
    value[0..14].split('').each_with_index { |e, i| (i + 1).odd? ? odds << e : evens << e }
    odd = odds.inject(0) { |sum, current_char| sum + DISPARI[(current_char.ord < 65 ? current_char.to_i : ((current_char.ord - 54) - 1))] }
    even = evens.inject(0) { |sum, current_char| sum + (current_char.ord < 65 ? current_char.to_i : current_char.ord - 65) }
    (((odd + even) % 26) + 65).chr == value[15].chr
  end
end
