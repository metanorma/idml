# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `Stories/Story_*.xml`. Stories carry text flow
    # content (paragraph and character style runs). This initial model
    # captures the root wrapper; full story tree modeling is incremental.
    class Story < Lutaml::Model::Serializable
      include Idml::Part

      part_file %r{\AStories/Story_[^/]+\.xml\z}

      attribute :dom_version, :string

      xml do
        root "Story"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
      end
    end
  end
end
