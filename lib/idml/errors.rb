# frozen_string_literal: true

module Idml
  module Errors
    class Error < StandardError; end
    class PackageNotFound < Error; end
    class InvalidPackage < Error; end
    class PartNotFound < Error; end
  end
end
