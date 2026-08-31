# frozen_string_literal: true

module Idml
  module Schema
    # Parses RelaxNG Compact element definitions into data:
    # element name → wire attribute names. Handles the Adobe
    # package schemas' shape (`NAME_Object = element Name { ... }`
    # with balanced braces; attributes as `attribute X { type }`).
    # Two consumers over this seam: the class generator script and
    # the schema-conformance spec.
    module Rnc
      ELEMENT_DEF = /(\w+)\s*+=\s*+element\s*+([\w:]+)\s*+\{/
      ATTRIBUTE_DEF = /attribute\s++(\w+)\s*+\{([^}]*)\}/

      module_function

      # { "Story" => [["Self", ...]], ... } for every element
      # definition across the given RNC files. An element defined
      # in several files keeps each definition as an alternative
      # (array of attribute-name arrays) — a class conforms when
      # its wire attributes equal ANY one alternative.
      def element_attribute_map(paths)
        definitions = Hash.new { |h, k| h[k] = [] }
        each_element(paths) do |element_name, body|
          definitions[element_name] << body_attributes(body)
        end
        definitions.to_h
      end

      # [xml_element_name, attrs_with_types] for one named
      # definition (`Story_Object`) in one file; nil when absent.
      # attrs_with_types: [["Self", "xsd:string"], ...].
      def element_definition(path, definition_name)
        src = File.read(path)
        prefix = /#{Regexp.escape(definition_name)}\s*=\s*element\s+/
        pattern = /#{prefix}([\w:]+)\s*\{/
        match = src.match(pattern)
        return nil unless match

        body = balanced_body(src, match.end(0))
        return nil unless body

        attrs_with_types = body.scan(ATTRIBUTE_DEF)
          .map { |name, type| [name, type.strip] }
        [match[1], attrs_with_types]
      end

      def body_attributes(body)
        body.scan(ATTRIBUTE_DEF).map(&:first).uniq
      end

      def each_element(paths, &block)
        paths.each do |path|
          scan_file(path, &block)
        end
      end

      def scan_file(path)
        src = File.read(path)
        src.scan(ELEMENT_DEF) do
          match = Regexp.last_match
          body = balanced_body(src, match.end(0))
          next unless body

          element_name = match[2].sub(/^idPkg:/, "")
          yield(element_name, body)
        end
      end

      # The balanced-brace body starting just after `from` (which
      # points past the opening brace); nil when unterminated.
      def balanced_body(src, from)
        depth = 1
        i = from
        while i < src.length && depth.positive?
          case src[i]
          when "{" then depth += 1
          when "}" then depth -= 1
          end
          i += 1
        end
        return nil if depth.positive?

        src[from...(i - 1)]
      end
    end
  end
end
