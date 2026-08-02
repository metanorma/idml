# frozen_string_literal: true

module Idml
  module Elements
    # `<Layer>` — a document layer. Defined in designmap.xml. Each page
    # item's `ItemLayer` attribute references a Layer's Self. Layers
    # control visibility, locking, and z-order.
    class Layer < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :visible, :boolean
      attribute :locked, :boolean
      attribute :ignore_wrap, :boolean
      attribute :show_guides, :boolean
      attribute :lock_guides, :boolean
      attribute :ui, :boolean
      attribute :expendable, :boolean
      attribute :printable, :boolean

      xml do
        root "Layer"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "Visible", to: :visible
        map_attribute "Locked", to: :locked
        map_attribute "IgnoreWrap", to: :ignore_wrap
        map_attribute "ShowGuides", to: :show_guides
        map_attribute "LockGuides", to: :lock_guides
        map_attribute "UI", to: :ui
        map_attribute "Expendable", to: :expendable
        map_attribute "Printable", to: :printable
      end
    end
  end
end
