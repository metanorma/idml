# frozen_string_literal: true

module Idml
  # The IDML packaging namespace, used on every part's root wrapper
  # element (idPkg:Spread, idPkg:Story, idPkg:Fonts, etc.). The actual
  # content elements inside (Spread, Story, FontFamily) are NOT in this
  # namespace — the wrapper just declares the prefix for idPkg-scoped
  # children.
  class PackagingNamespace < Lutaml::Xml::Namespace
    uri "http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
    prefix_default "idPkg"
  end
end
