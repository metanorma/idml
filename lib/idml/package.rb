# frozen_string_literal: true

module Idml
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
