# frozen_string_literal: true

module Idml
  module Validation
    autoload :Validator, "#{__dir__}/validation/validator"
    autoload :Result,    "#{__dir__}/validation/result"

    # Default schema root: the development tree's generated schemas.
    # Override per-call by passing `schema_root:` to Validator.new.
    DEFAULT_SCHEMA_ROOT = File.expand_path(
      "../../../reference-docs/schemas/package", __dir__
    )
  end
end
