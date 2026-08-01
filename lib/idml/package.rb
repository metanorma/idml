# frozen_string_literal: true

module Idml
  # Read/write access to an IDML package's ZIP container. A Package
  # holds a path; ZIP and part reads are lazy. Typed part access goes
  # through `#part(name)` which dispatches via `Idml::Parts.class_for`.
  #
  # @example Open a package and read the designmap
  #   pkg = Idml::Package.new("path/to/file.idml")
  #   dm = pkg.designmap
  #   puts dm.dom_version
  #
  # @example Write a new package
  #   parts = { "mimetype" => "...", "designmap.xml" => "..." }
  #   Idml::Package.write(parts: parts, to: "out.idml")
  class Package
    # The IDML UCF container's mimetype entry name. Per the IDML spec, this
    # entry must appear first in the archive and be stored uncompressed.
    MIMETYPE_ENTRY = "mimetype"
    private_constant :MIMETYPE_ENTRY

    def initialize(path)
      raise Errors::PackageNotFound, path.to_s unless File.exist?(path)

      @path = File.expand_path(path)
    end

    attr_reader :path

    def designmap
      @designmap ||= part("designmap.xml")
    end

    def backing_story
      @backing_story ||= part("XML/BackingStory.xml")
    end

    def spreads
      @spreads ||= part_names.grep(%r{\ASpreads/}).map { |n| part(n) }
    end

    def master_spreads
      @master_spreads ||= part_names.grep(%r{\AMasterSpreads/}).map do |n|
        part(n)
      end
    end

    def stories
      @stories ||= part_names.grep(%r{\AStories/}).map { |n| part(n) }
    end

    def fonts
      return unless has_part?("Resources/Fonts.xml")

      @fonts ||= part("Resources/Fonts.xml")
    end

    def graphic
      return unless has_part?("Resources/Graphic.xml")

      @graphic ||= part("Resources/Graphic.xml")
    end

    def style
      return unless has_part?("Resources/Styles.xml")

      @style ||= part("Resources/Styles.xml")
    end

    def style_mapping
      if has_part?("Resources/StyleMapping.xml")
        @style_mapping ||=
          part("Resources/StyleMapping.xml")
      end
    end

    def preferences
      if has_part?("Resources/Preferences.xml")
        @preferences ||=
          part("Resources/Preferences.xml")
      end
    end

    def tags
      @tags ||= part("XML/Tags.xml") if has_part?("XML/Tags.xml")
    end

    def mapping
      @mapping ||= part("XML/Mapping.xml") if has_part?("XML/Mapping.xml")
    end

    def dom_version
      designmap&.dom_version
    end

    def part_names
      @part_names ||= with_zip do |zip_file|
        names = []
        zip_file.each do |entry|
          names << entry.name if entry.name && !entry.name.empty?
        end
        names.sort
      end
    end

    def has_part?(name)
      part_names.include?(name)
    end

    def read_part(name)
      raise Errors::PartNotFound, name unless has_part?(name)

      with_zip { |zip_file| zip_file.read(name) }
    end

    # Returns a typed part instance for `name` when a class is registered
    # for that file pattern (e.g. Designmap for designmap.xml). Falls
    # back to Parts::Raw — a lossless XML wrapper — for unmodeled parts.
    def part(name)
      xml = read_part(name)
      klass = Idml::Parts.class_for(name)
      return Idml::Parts::Raw.from_xml(xml) unless klass

      klass.from_xml(xml)
    end

    def each_part
      return enum_for(:each_part) unless block_given?

      with_zip do |zip_file|
        zip_file.each do |entry|
          next if entry.directory?

          yield entry.name, entry.get_input_stream.read
        end
      end
    end

    def self.write(parts:, to:)
      raise Errors::InvalidPackage, "no parts given" if parts.empty?

      output_path = File.expand_path(to)
      FileUtils.mkdir_p(File.dirname(output_path))
      write_to_zip(parts, output_path)
      new(output_path)
    end

    private

    def with_zip(&)
      Zip::File.open(@path, &)
    rescue Errno::ENOENT => e
      raise Errors::PackageNotFound, e.message
    rescue Zip::Error => e
      raise Errors::InvalidPackage, e.message
    end

    def self.write_to_zip(parts, output_path)
      with_mimetype_tempfile(parts[MIMETYPE_ENTRY]) do |mimetype_path|
        Zip::File.open(output_path, Zip::File::CREATE) do |zip_file|
          write_mimetype(zip_file, mimetype_path)
          write_remaining_parts(zip_file, parts)
        end
      end
    end
    private_class_method :write_to_zip

    def self.write_mimetype(zip_file, mimetype_path)
      return unless mimetype_path

      zip_file.add_stored(MIMETYPE_ENTRY, mimetype_path)
    end
    private_class_method :write_mimetype

    def self.write_remaining_parts(zip_file, parts)
      parts.each do |name, content|
        next if name == MIMETYPE_ENTRY

        zip_file.get_output_stream(name) { |stream| stream.write(content) }
      end
    end
    private_class_method :write_remaining_parts

    def self.with_mimetype_tempfile(content)
      return yield(nil) unless content

      Tempfile.create("idml-mimetype") do |tmp|
        tmp.write(content)
        tmp.close
        yield tmp.path
      end
    end
    private_class_method :with_mimetype_tempfile
  end
end
