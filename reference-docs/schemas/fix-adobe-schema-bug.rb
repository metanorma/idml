#!/usr/bin/env ruby
# frozen_string_literal: true

# Patches Adobe's known bug in datatype.rnc output from
# app.generateIDMLSchema(). The generator leaks raw documentation prose
# (a wiki-style table about Folio metadata) into the RNC between the
# last valid comment and the next valid type definition. The leaked
# range is invalid RNC, and every downstream part file fails validation
# because the datatype.rnc parse failure cascades — every *_EnumValue
# reference becomes undefined.
#
# The fix: comment out the broken range. Matches the fix
# PatrickAgostini applied in their pre-extracted schemas at
# ~/src/external/idml/schema/rnc/Packaging/datatype.rnc.
#
# Affects both the package and the single (consolidated) schema variants.
# Idempotent: detects already-commented sections and skips them.
#
# Usage:
#   ruby fix-adobe-schema-bug.rb                       # patch every datatype.rnc under this dir
#   ruby fix-adobe-schema-bug.rb path/to/datatype.rnc  # patch specific file(s)

# Markers delimiting the broken prose block. The block starts AFTER
# this comment line (which is valid RNC) and ends RIGHT BEFORE this
# RNC definition (also valid). Every line strictly between needs
# commenting.
START_MARKER = /# Metadata information for an exported folio\.\s*\z/
END_MARKER = /\AExportFolioMetaData_TypeDef\s*=/

def patched?(lines)
  start_idx = lines.index { |l| l.match?(START_MARKER) }
  return false unless start_idx && lines[start_idx + 1]

  # If the line immediately after the start marker is already commented
  # (a blank-comment "#" or any "# ..."), the file has been patched.
  lines[start_idx + 1].start_with?("#")
end

def patch(path)
  return :missing unless File.file?(path)

  lines = File.readlines(path, chomp: true)
  return :already_patched if patched?(lines)

  start_idx = lines.index { |l| l.match?(START_MARKER) }
  end_idx = lines.index { |l| l.match?(END_MARKER) }
  return :markers_not_found unless start_idx && end_idx && end_idx > start_idx

  ((start_idx + 1)...end_idx).each do |i|
    line = lines[i]
    next if line.start_with?("#")

    lines[i] = line.strip.empty? ? "#" : "# #{line}"
  end

  File.write(path, lines.join("\n") + "\n")
  :patched
end

default_glob = File.expand_path("**/datatype.rnc", __dir__)
paths = ARGV.empty? ? Dir[default_glob] : ARGV

if paths.empty?
  warn "no datatype.rnc files found"
  exit 1
end

results = paths.map { |p| [p, patch(p)] }
results.each { |p, r| puts "#{p}: #{r}" }
