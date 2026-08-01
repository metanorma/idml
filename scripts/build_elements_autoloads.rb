#!/usr/bin/env ruby
# frozen_string_literal: true

# Rebuilds lib/idml/elements.rb from the actual class names defined in
# each element file. Avoids name/file mismatches when prefixing is used
# (e.g., pref_*.rb files defining non-prefixed class names).

require "pathname"

elements_dir = Pathname.new("lib/idml/elements")
files = Dir.glob(elements_dir.join("*.rb"))

entries = files.map do |path|
  rel = path.sub("lib/idml/elements/", "").delete_suffix(".rb")
  source = File.read(path)
  match = source.match(/^\s*class\s+(\w+)\s+</)
  abort "no class in #{path}" unless match

  [match[1], rel]
end

# Detect name collisions (same class name in multiple files).
by_class = entries.group_by(&:first)
collisions = by_class.select { |_, files| files.length > 1 }
unless collisions.empty?
  abort "class name collisions:\n#{collisions.map { |cls, files| "  #{cls}: #{files.map(&:last).join(', ')}" }.join("\n")}"
end

File.open("lib/idml/elements.rb", "w") do |f|
  f.puts "# frozen_string_literal: true"
  f.puts
  f.puts "module Idml"
  f.puts "  # Typed models for IDML elements that appear inside parts. Every"
  f.puts "  # element class is generated from its `_Object` definition in the"
  f.puts "  # RNC schemas at `reference-docs/schemas/package/` via"
  f.puts "  # `scripts/rnc_to_lutaml.rb` + `scripts/assemble_element.rb`"
  f.puts "  # (or `scripts/generate_all_objects.rb` for bulk generation)."
  f.puts "  module Elements"
  entries.sort_by(&:first).each do |cls, rel|
    f.puts %(    autoload :#{cls}, "idml/elements/#{rel}")
  end
  f.puts "  end"
  f.puts "end"
end

puts "wrote lib/idml/elements.rb (#{entries.length} autoloads)"
