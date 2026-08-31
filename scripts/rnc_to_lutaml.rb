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
# RNC parsing lives in Idml::Schema::Rnc (shared with the
# schema-conformance spec); this script owns presentation only.

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "idml"

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

rnc_path, element_name = ARGV
abort "usage: #{$PROGRAM_NAME} <rnc-file> <ElementName>" unless rnc_path && element_name

xml_root, attrs = Idml::Schema::Rnc.element_definition(rnc_path, element_name)
abort "#{element_name} not found in #{rnc_path}" unless xml_root

puts "# xml root: <#{xml_root}>"
puts "# source: #{rnc_path} (#{element_name})"
puts "# #{attrs.length} attributes"
puts
puts "# attribute declarations:"
attrs.each do |name, type|
  lutaml = lutaml_type(type.split(/\s/).first)
  puts "attribute :#{ruby_attr_name(name)}, :#{lutaml}"
end
puts
puts "xml do"
puts %(  root "#{xml_root.sub(/^idPkg:/, '')}")
attrs.each do |name, _type| # rubocop:disable Style/HashEachMethods
  puts %(  map_attribute "#{name}", to: :#{ruby_attr_name(name)})
end
puts "end"
