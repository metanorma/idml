# frozen_string_literal: true

module Idml
  module Validation
    # Immutable result of validating one part against its RNG schema.
    # `#ok?` is true when there are no errors. `#errors` is an Array of
    # Jing-formatted error strings (with line numbers).
    Result = Struct.new(:part_name, :ok, :errors) do
      def ok?
        ok
      end
    end
  end
end
