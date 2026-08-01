# frozen_string_literal: true

require "lutaml/model"
require "zip"
require "fileutils"
require "tempfile"

module Idml
  autoload :VERSION, "#{__dir__}/idml/version"
  autoload :Errors,  "#{__dir__}/idml/errors"
  autoload :Package, "#{__dir__}/idml/package"
end
