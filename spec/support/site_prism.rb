# frozen_string_literal: true

Dir[File.join(File.dirname(__FILE__), '../sections/**/*.rb')].each { |f| require f }
Dir[File.join(File.dirname(__FILE__), '../pages/**/*.rb')].each { |f| require f }
