# frozen_string_literal: true

module Idml
  # Composition operations on packages. Each operation is its own class
  # (command pattern) so adding a new op doesn't require editing Package
  # or any existing op (open/closed). Every op takes a Package in its
  # constructor and returns a new Package from #call — no in-place
  # mutation.
  module Composition
    autoload :Prefix,            "#{__dir__}/composition/prefix"
    autoload :InsertIdml,        "#{__dir__}/composition/insert_idml"
    autoload :AddPageFromIdml,   "#{__dir__}/composition/add_page_from_idml"
    autoload :ImportXml,         "#{__dir__}/composition/import_xml"
    autoload :ExportXml,         "#{__dir__}/composition/export_xml"
  end
end
