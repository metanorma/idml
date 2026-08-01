#!/usr/bin/env ruby
# frozen_string_literal: true

# Generates lib/idml/parts/preferences.rb from the actual _Object list
# in Preferences.rnc. Same pattern applies to other multi-element parts.

require "shellwords"

rnc_file = ARGV[0] || "reference-docs/schemas/package/Resources/Preferences.rnc"
output = ARGV[1] || "lib/idml/parts/preferences.rb"
part_class = ARGV[2] || "Preferences"
xml_root = ARGV[3] || "Preferences"

src = File.read(rnc_file)
objects = src.scan(/^([A-Za-z]+_Object) = element ([A-Za-z]+)/).uniq

def snake(name)
  name
    .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    .gsub(/([a-z\d])([A-Z])/, '\1_\2')
    .downcase
end

out = []
out << "# frozen_string_literal: true"
out << ""
out << "module Idml"
out << "  module Parts"
out << "    # Typed model for the package's `#{xml_root.downcase}.xml` part."
out << "    # Every child element from `#{rnc_file}` is typed — generated"
out << "    # via `scripts/rnc_to_lutaml.rb` + `scripts/assemble_element.rb`."
out << "    class #{part_class} < Lutaml::Model::Serializable"
out << "      include Idml::Part"
out << ""
out << "      part_file \"Resources/#{xml_root}.xml\""
out << ""
out << "      attribute :dom_version, :string"
objects.each do |_rule, xml_name| # rubocop:disable Style/HashEachMethods
  ruby_attr = snake(xml_name)
  out << "      attribute :#{ruby_attr}, Idml::Elements::#{xml_name}, collection: true"
end
out << ""
out << "      xml do"
out << "        root \"#{xml_root}\""
out << "        namespace Idml::PackagingNamespace"
out << "        map_attribute \"DOMVersion\", to: :dom_version"
objects.each do |_rule, xml_name| # rubocop:disable Style/HashEachMethods
  ruby_attr = snake(xml_name)
  out << "        map_element \"#{xml_name}\", to: :#{ruby_attr}"
end
out << "      end"
out << "    end"
out << "  end"
out << "end"

File.write(output, "#{out.join("\n")}\n")
puts "wrote #{output} (#{objects.length} typed children)"
