# frozen_string_literal: true

require "lutaml/model"
require "zip"
require "fileutils"
require "tempfile"

module Idml
  autoload :VERSION,            "#{__dir__}/idml/version"
  autoload :Errors,             "#{__dir__}/idml/errors"
  autoload :PackagingNamespace, "#{__dir__}/idml/namespace"
  autoload :Part,               "#{__dir__}/idml/part"
  autoload :Parts,              "#{__dir__}/idml/parts"
  autoload :Package,            "#{__dir__}/idml/package"
  autoload :Validation,         "#{__dir__}/idml/validation"
  autoload :Composition,        "#{__dir__}/idml/composition"
  autoload :Geometry,           "#{__dir__}/idml/geometry"

  # Convenience: open an IDML file. Equivalent to Package.new(path).
  def self.open(path)
    Package.new(path)
  end
end
