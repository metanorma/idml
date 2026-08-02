# frozen_string_literal: true

module Idml
  module Render
    module PdfrbExt
      # PDF `Do` operator: invoke an XObject (image or form) by name.
      # pdfrb 0.3.0 doesn't include this operator; we register it here
      # so Canvas#emit_op can draw images.
      class InvokeXObject < Pdfrb::Content::Operator::Base
        class << self
          def name
            "Do"
          end

          def serialize(_serializer, xobject_name)
            "/#{xobject_name} Do\n"
          end
        end

        register
      end
    end
  end
end
