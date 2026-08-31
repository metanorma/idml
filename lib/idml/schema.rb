# frozen_string_literal: true

module Idml
  # Namespace for adapters over the committed RelaxNG Compact
  # schemas (`reference-docs/schemas/`). The RNC files are the
  # authoritative interface of the Elements layer — this namespace
  # turns them into data for the generator script and the
  # conformance spec (two consumers, one seam).
  module Schema
    autoload :Rnc, "#{__dir__}/schema/rnc"
  end
end
