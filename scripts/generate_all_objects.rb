#!/usr/bin/env ruby
# frozen_string_literal: true

# Bulk-generate element classes for every _Object type in a given RNC.
# Usage: scripts/generate_all_objects.rb <rnc-file> [prefix]
# where prefix is an optional string prepended to file names to avoid
# collisions (e.g., "pref_" for Preferences to avoid colliding with
# Styles' ParagraphStyle).

require "shellwords"

rnc_file = ARGV[0]
prefix = ARGV[1] || ""

abort "usage: #{$PROGRAM_NAME} <rnc-file> [prefix]" unless rnc_file

src = File.read(rnc_file)
# Match `Foo_Object = element Foo {` at column 0.
objects = src.scan(/^([A-Za-z]+_Object) = element ([A-Za-z]+)/)
objects.uniq!

def snake(name)
  name
    .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    .gsub(/([a-z\d])([A-Z])/, '\1_\2')
    .downcase
end

objects.each do |rule_name, xml_name|
  cls = xml_name
  file_name = "#{prefix}#{snake(cls)}.rb"
  output_path = File.join("lib/idml/elements", file_name)
  cmd = ["ruby", "scripts/assemble_element.rb", rnc_file, rule_name, cls,
         output_path, "", xml_name]
  system(*cmd)
end

puts "generated #{objects.length} element classes from #{rnc_file}"
