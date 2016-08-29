# frozen_string_literal: true

require "bundler/setup"
require "attr_injected"

require "pry"
require "pry-byebug"

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |file| require file }
