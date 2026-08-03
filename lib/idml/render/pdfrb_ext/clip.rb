# frozen_string_literal: true

module Idml
  module Render
    module PdfrbExt
      # PDF `W` operator: intersect current path with clipping path
      # (nonzero winding rule). Must be followed by `n` to end the path.
      class Clip < Pdfrb::Content::Operator::NoArg
        class << self
          def name
            "W"
          end
        end

        register
      end

      # PDF `n` operator: end path without painting. Commonly used
      # after `W` to set a clip without filling or stroking.
      class EndPath < Pdfrb::Content::Operator::NoArg
        class << self
          def name
            "n"
          end
        end

        register
      end
    end
  end
end
