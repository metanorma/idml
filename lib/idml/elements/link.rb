# frozen_string_literal: true

module Idml
  module Elements
    # `<Link>` — a resource link. Appears inside `<Image>` and other
    # graphic-bearing page items. Carries the `LinkResourceURI` that
    # points to the external asset file.
    class Link < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :link_resource_uri, :string
      attribute :link_resource_format, :string
      attribute :stored_state, :string
      attribute :link_resource_modified, :boolean

      xml do
        root "Link"
        map_attribute "Self", to: :self_attr
        map_attribute "LinkResourceURI", to: :link_resource_uri
        map_attribute "LinkResourceFormat", to: :link_resource_format
        map_attribute "StoredState", to: :stored_state
        map_attribute "LinkResourceModified", to: :link_resource_modified
      end
    end
  end
end
