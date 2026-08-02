# frozen_string_literal: true

module Idml
  module Render
    # Extensions to the pdfrb gem for operators not yet implemented in
    # pdfrb 0.3.0 (e.g., XObject invocation via `Do`).
    module PdfrbExt
      autoload :InvokeXObject, "#{__dir__}/pdfrb_ext/invoke_xobject"
    end
  end
end
