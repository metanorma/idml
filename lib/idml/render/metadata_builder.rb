# frozen_string_literal: true

require "time"

module Idml
  module Render
    # Builds the PDF Info-dict metadata hash by merging XMP-extracted
    # values from `META-INF/metadata.xml` over sensible defaults.
    # Extracted from `Pipeline` for SRP — Pipeline orchestrates
    # rendering, this module owns metadata assembly.
    class MetadataBuilder
      XMP_PATH = "META-INF/metadata.xml"

      def initialize(package)
        @package = package
      end

      # Returns a hash with Producer/CreationDate defaults, overridden
      # by any XMP-supplied fields (Title, Author, Subject, Keywords,
      # Creator, CreationDate, ModDate). XMP dates are converted from
      # ISO 8601 to PDF `D:YYYYMMDDHHmmss` format.
      def build
        defaults.merge(xmp_fields) { |_key, default, xmp| xmp || default }
      end

      private

      def defaults
        {
          Producer: "idml gem v#{Idml::VERSION}",
          CreationDate: pdf_date(Time.now.utc),
        }
      end

      def xmp_fields
        return {} unless xmp_packet

        {
          Title: xmp_packet.title,
          Author: xmp_packet.author,
          Subject: xmp_packet.description,
          Keywords: xmp_packet.keywords,
          Creator: xmp_packet.creator_tool,
          CreationDate: pdf_date_string(xmp_packet.create_date),
          ModDate: pdf_date_string(xmp_packet.modify_date),
        }.compact
      end

      def xmp_packet
        return nil unless @package.has_part?(XMP_PATH)

        @xmp_packet ||= begin
          xml = @package.read_part(XMP_PATH)
          Parts::XmpMeta.from_xml(xml).rdf
        rescue StandardError
          nil
        end
      end

      def pdf_date_string(iso8601)
        return nil unless iso8601

        pdf_date(Time.iso8601(iso8601))
      rescue ArgumentError
        nil
      end

      def pdf_date(time)
        time.strftime("D:%Y%m%d%H%M%S+00'00'")
      end
    end
  end
end
