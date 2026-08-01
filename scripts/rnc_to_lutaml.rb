#!/usr/bin/env ruby
# frozen_string_literal: true

# Translates a RelaxNG Compact element definition into lutaml-model
# Ruby attribute + xml-mapping declarations.
#
# Usage:
#   scripts/rnc_to_lutaml.rb <rnc-file> <ElementName>
#
# Example:
#   scripts/rnc_to_lutaml.rb reference-docs/schemas/package/Stories/Story.rnc Story_Object
#
# The script reads the named element definition (e.g.,
# `Story_Object = element Story { ... }`), extracts every `attribute
# Name { Type }?` line, and prints Ruby code suitable for pasting
# into a Lutaml::Model::Serializable subclass.
#
# Generated output:
#   attribute :self_attr, :string
#   attribute :first_line_indent, :float
#   # ... etc.
#   xml do
#     map_attribute "Self", to: :self_attr
#     map_attribute "FirstLineIndent", to: :first_line_indent
#   end

require "strscan"

RESERVED_RUBY_NAMES = %w[self class integer float string end do begin ensure
                         rescue retry next return break yield nil true false].freeze

def lutaml_type(rnc_type)
  case rnc_type
  when "xsd:string" then :string
  when "xsd:boolean" then :boolean
  when "xsd:int", "xsd:integer" then :integer
  when "xsd:short", "xsd:long", "xsd:byte" then :integer
  when "xsd:double", "xsd:decimal", "xsd:float" then :float
  when "xsd:dateTime" then :string
  else
    :string # enums and complex typedefs default to string
  end
end

def snake_case(name)
  name
    .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    .gsub(/([a-z\d])([A-Z])/, '\1_\2')
    .downcase
end

def ruby_attr_name(xml_name)
  base = snake_case(xml_name)
  return "#{base}_attr" if RESERVED_RUBY_NAMES.include?(base)

  base
end

def extract_element(rnc_path, element_name)
  src = File.read(rnc_path)
  pattern = /#{Regexp.escape(element_name)}\s*=\s*element\s+([\w:]+)\s*\{/
  match = src.match(pattern)
  abort "#{element_name} not found in #{rnc_path}" unless match

  xml_element_name = match[1]
  start_pos = match.end(0)

  # Walk the brace structure to find the matching close.
  depth = 1
  i = start_pos
  while i < src.length && depth.positive?
    case src[i]
    when "{" then depth += 1
    when "}" then depth -= 1
    end
    i += 1
  end
  body = src[start_pos...(i - 1)]

  [xml_element_name, body]
end

def extract_attributes(body)
  attrs = []
  body.scan(/^\s*attribute\s+(\w+)\s*\{\s*([^}]+)\}/) do |name, type|
    attrs << [name, type.strip]
  end
  attrs
end

rnc_path, element_name = ARGV
abort "usage: #{$PROGRAM_NAME} <rnc-file> <ElementName>" unless rnc_path && element_name

xml_root, body = extract_element(rnc_path, element_name)
attrs = extract_attributes(body)

puts "# xml root: <#{xml_root}>"
puts "# source: #{rnc_path} (#{element_name})"
puts "# #{attrs.length} attributes"
puts
puts "attribute :_placeholder_, :string # remove me"
puts
puts "xml do"
puts "  root \"#{xml_root.sub(/^idPkg:/, '')}\""
attrs.each_key do |name|
  puts %(  map_attribute "#{name}", to: :#{ruby_attr_name(name)})
end
puts "end"
puts
puts "# attribute declarations:"
attrs.each do |name, type|
  lutaml = lutaml_type(type.split(/\s/).first)
  puts "attribute :#{ruby_attr_name(name)}, :#{lutaml}"
end
