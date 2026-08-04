# frozen_string_literal: true

require "lutaml/model"

module Idml
  module Parts
    # XMP (Extensible Metadata Platform) parser for IDML's
    # `META-INF/metadata.xml`. The packet is RDF/XML with multiple
    # namespaces (`dc:`, `xmp:`, `pdf:`, `xmpMM:`, etc.).
    #
    # Per Lutaml's namespace API, each namespaced element is a
    # separate `Serializable` subclass that carries its own
    # `namespace`. The parent `<rdf:Description>` composes the
    # children via `map_element`, with the namespace binding handled
    # on each child class.
    module Xmp
      class RdfNamespace < Lutaml::Xml::Namespace
        uri "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        prefix_default "rdf"
      end

      class DcNamespace < Lutaml::Xml::Namespace
        uri "http://purl.org/dc/elements/1.1/"
        prefix_default "dc"
      end

      class XmpNamespace < Lutaml::Xml::Namespace
        uri "http://ns.adobe.com/xap/1.0/"
        prefix_default "xmp"
      end

      class XmetaNamespace < Lutaml::Xml::Namespace
        uri "adobe:ns:meta/"
        prefix_default "x"
      end

      # Single direct-value element. Subclasses set the element name
      # and namespace.
      class Leaf < Lutaml::Model::Serializable
        attribute :value, :string
      end

      class Format < Leaf
        xml do
          root "format"
          namespace DcNamespace
          map_content to: :value
        end
      end

      class CreatorTool < Leaf
        xml do
          root "CreatorTool"
          namespace XmpNamespace
          map_content to: :value
        end
      end

      class CreateDate < Leaf
        xml do
          root "CreateDate"
          namespace XmpNamespace
          map_content to: :value
        end
      end

      class ModifyDate < Leaf
        xml do
          root "ModifyDate"
          namespace XmpNamespace
          map_content to: :value
        end
      end

      class MetadataDate < Leaf
        xml do
          root "MetadataDate"
          namespace XmpNamespace
          map_content to: :value
        end
      end

      # rdf:li element inside rdf:Alt / rdf:Seq / rdf:Bag containers.
      class ListItem < Lutaml::Model::Serializable
        attribute :lang, :string
        attribute :value, :string

        xml do
          root "li"
          namespace RdfNamespace
          map_attribute "lang", to: :lang
          map_content to: :value
        end
      end

      # rdf:Alt — alternative-language values. Used for dc:title and
      # dc:description.
      class Alt < Lutaml::Model::Serializable
        attribute :items, ListItem, collection: true

        xml do
          root "Alt"
          namespace RdfNamespace
          map_element "li", to: :items
        end

        def default_value
          x_default = items.find { |i| i.lang == "x-default" }
          (x_default || items.first)&.value
        end
      end

      # rdf:Seq — ordered sequence. Used for dc:creator.
      class Seq < Lutaml::Model::Serializable
        attribute :items, ListItem, collection: true

        xml do
          root "Seq"
          namespace RdfNamespace
          map_element "li", to: :items
        end

        def values
          items.filter_map(&:value)
        end
      end

      # rdf:Bag — unordered set. Used for dc:subject.
      class Bag < Lutaml::Model::Serializable
        attribute :items, ListItem, collection: true

        xml do
          root "Bag"
          namespace RdfNamespace
          map_element "li", to: :items
        end

        def values
          items.filter_map(&:value)
        end
      end

      # Container-wrapped dc elements.
      class Title < Lutaml::Model::Serializable
        attribute :alt, Alt

        xml do
          root "title"
          namespace DcNamespace
          map_element "Alt", to: :alt
        end

        def value
          alt&.default_value
        end
      end

      class DcDescription < Lutaml::Model::Serializable
        attribute :alt, Alt

        xml do
          root "description"
          namespace DcNamespace
          map_element "Alt", to: :alt
        end

        def value
          alt&.default_value
        end
      end

      class Creator < Lutaml::Model::Serializable
        attribute :seq, Seq

        xml do
          root "creator"
          namespace DcNamespace
          map_element "Seq", to: :seq
        end

        def values
          seq&.values || []
        end
      end

      class Subject < Lutaml::Model::Serializable
        attribute :bag, Bag

        xml do
          root "subject"
          namespace DcNamespace
          map_element "Bag", to: :bag
        end

        def values
          bag&.values || []
        end
      end
    end

    # Single `<rdf:Description>` element from an XMP packet. Combines
    # children from multiple namespaces (`dc:`, `xmp:`) by composing
    # nested `Serializable` models — each child carries its own
    # `namespace` declaration per Lutaml's namespace API.
    class XmpDescription < Lutaml::Model::Serializable
      attribute :format, Xmp::Format
      attribute :title, Xmp::Title
      attribute :creator, Xmp::Creator
      attribute :description, Xmp::DcDescription
      attribute :subject, Xmp::Subject
      attribute :creator_tool, Xmp::CreatorTool
      attribute :create_date, Xmp::CreateDate
      attribute :modify_date, Xmp::ModifyDate
      attribute :metadata_date, Xmp::MetadataDate

      xml do
        root "Description"
        namespace Xmp::RdfNamespace
        map_element "format", to: :format
        map_element "title", to: :title
        map_element "creator", to: :creator
        map_element "description", to: :description
        map_element "subject", to: :subject
        map_element "CreatorTool", to: :creator_tool
        map_element "CreateDate", to: :create_date
        map_element "ModifyDate", to: :modify_date
        map_element "MetadataDate", to: :metadata_date
      end

      def author
        creator&.values&.first
      end

      def keywords
        subject&.values&.join(", ")
      end
    end

    # `<rdf:RDF>` — collection of `<rdf:Description>` siblings inside
    # an XMP packet. Per IDML's META-INF/metadata.xml, there is
    # typically one Description per schema group.
    class XmpRdf < Lutaml::Model::Serializable
      attribute :descriptions, XmpDescription, collection: true

      xml do
        root "RDF"
        namespace Xmp::RdfNamespace
        map_element "Description", to: :descriptions
      end

      # Merged view across all Descriptions. Each attribute returns
      # the first non-nil value across the descriptions.
      def first_description
        descriptions.first
      end

      def title
        descriptions.map(&:title).find(&:itself)&.value
      end

      def author
        descriptions.filter_map(&:author).first
      end

      def subject
        descriptions.filter_map(&:subject).find(&:itself)&.values
      end

      def keywords
        subject&.join(", ")
      end

      def description
        descriptions.map(&:description).find(&:itself)&.value
      end

      def creator_tool
        descriptions.filter_map(&:creator_tool).first&.value
      end

      def create_date
        descriptions.filter_map(&:create_date).first&.value
      end

      def modify_date
        descriptions.filter_map(&:modify_date).first&.value
      end
    end

    # `<x:xmpmeta>` — outer wrapper of an XMP packet.
    class XmpMeta < Lutaml::Model::Serializable
      attribute :rdf, XmpRdf

      xml do
        root "xmpmeta"
        namespace Xmp::XmetaNamespace
        map_element "RDF", to: :rdf
      end

      def description
        rdf&.first_description
      end
    end
  end
end
